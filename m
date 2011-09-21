Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab1IUPi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 11:38:57 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36497 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab1IUPiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 11:38:55 -0400
Subject: Re: [PATCH] kconfig: Add merge_config.sh script
From: John Stultz <john.stultz@linaro.org>
To: Michal Marek <mmarek@suse.cz>
Cc: lkml <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
        gthelen@google.com, tartler@cs.fau.de,
        Dmitry Fink <Dmitry.Fink@palm.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Eric B Munson <ebmunson@us.ibm.com>,
        Bruce Ashfield <Bruce.Ashfield@windriver.com>,
        linux-kbuild@vger.kernel.org
In-Reply-To: <4E79D43F.6040807@suse.cz>
References: <1316582561-23066-1-git-send-email-john.stultz@linaro.org>
	 <4E79D43F.6040807@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Sep 2011 08:36:29 -0700
Message-ID: <1316619389.3112.215.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
x-cbid: 11092115-6078-0000-0000-0000010954CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-21 at 14:10 +0200, Michal Marek wrote:
> On 21.9.2011 07:22, John Stultz wrote:
> > After noticing almost every distro has their own method of managing
> > config fragments, I went looking at some best practices, and wanted
> > to try to consolidate some of the different approaches so this fairly
> > simple infrastructure can be shared (and new distros/build systems
> > don't have to implement yet another config fragment merge script).
> > 
> > This script is most influenced by the Windriver tools used in
> > the Yocto Project, reusing some portions found there.
> > 
> > This script merges multiple config fragments, warning on any
> > overrided values. It then sets any unspecified values to their
> > default, then finally checks to make sure no specified value was
> > dropped due to unsatisfied dependencies.
> > 
> > I'm sure I'm sure this implementation won't work for everyone, and
> > I expect it will need to evolve to adapt for various use cases.
> > But I think its a reasonable starting point.
> > 
> > v2: Reworked to use alldefconfig instead of the proposed
> > olddefconfig as suggested by Sam Ravnborg.
> > 
> > Thanks to Darren Hart for early review and feedback!
> > 
> > Please let me know if you have any comments or thoughts!
> > 
> > CC: Sam Ravnborg <sam@ravnborg.org>
> > CC: gthelen@google.com
> > CC: tartler@cs.fau.de
> > CC: Dmitry Fink <Dmitry.Fink@palm.com>
> > CC: Darren Hart <dvhart@linux.intel.com>
> > CC: Eric B Munson <ebmunson@us.ibm.com>
> > CC: Bruce Ashfield <Bruce.Ashfield@windriver.com>
> > CC: Michal Marek <mmarek@suse.cz>
> > CC: linux-kbuild@vger.kernel.org
> > Signed-off-by: John Stultz <john.stultz@linaro.org>
> > ---
> >  scripts/kconfig/merge_config.sh |   71 +++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 71 insertions(+), 0 deletions(-)
> >  create mode 100755 scripts/kconfig/merge_config.sh
> > 
> > diff --git a/scripts/kconfig/merge_config.sh b/scripts/kconfig/merge_config.sh
> > new file mode 100755
> > index 0000000..fda0139
> > --- /dev/null
> > +++ b/scripts/kconfig/merge_config.sh
> > @@ -0,0 +1,71 @@
> > +#!/bin/sh
> > +#  merge_config.sh - Takes a list of config fragment values, and merges
> > +#  them one by one. Provides warnings on overridden values, and specified
> > +#  values that did not make it to the resulting .config file (due to missed
> > +#  dependencies or config symbol removal).
> > +#
> > +#  Portions reused from kconf_check and generate_cfg:
> > +#  http://git.yoctoproject.org/cgit/cgit.cgi/yocto-kernel-tools/tree/tools/kconf_check
> > +#  http://git.yoctoproject.org/cgit/cgit.cgi/yocto-kernel-tools/tree/tools/generate_cfg
> > +#
> > +#  Copyright (c) 2009-2010 Wind River Systems, Inc.
> > +#  Copyright 2011 Linaro
> > +#
> > +#  This program is free software; you can redistribute it and/or modify
> > +#  it under the terms of the GNU General Public License version 2 as
> > +#  published by the Free Software Foundation.
> > +#
> > +#  This program is distributed in the hope that it will be useful,
> > +#  but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> > +#  See the GNU General Public License for more details.
> > +
> > +MERGE_LIST=$*
> > +
> > +
> > +TMP_FILE=$(mktemp ./.tmp.config.XXXXXXXXXX)
> > +
> > +# Merge files, printing warnings on overrided values
> > +for MERGE_FILE in $MERGE_LIST ; do
> > +	echo "Merging $MERGE_FILE"
> > +	CFG_LIST=`cat $MERGE_FILE | \
> > +	  sed 's/^\(# \)\{0,1\}\(CONFIG_[a-zA-Z0-9_]*\)[= ].*/\2/'`
> > +	for CFG in $CFG_LIST ; do
> > +		grep -q -w $CFG $TMP_FILE
> > +		if [ $? == 0 ] ; then
> > +			PREV_VAL=`grep -w $CFG $TMP_FILE`
> > +			NEW_VAL=`grep -w $CFG $MERGE_FILE`
> > +			if [ "x$PREV_VAL" != "x$NEW_VAL" ] ; then
> > +			echo Value of $CFG is redefined by fragment $MERGE_FILE:
> > +			echo Previous  value: `grep -w $CFG $TMP_FILE`
> > +			echo New value:       `grep -w $CFG $MERGE_FILE`
> 
> kconfig already warns when a symbol appears multiple times in .config.
> If really wanted, a verbose mode that show the  previous and new value
> could be added as well.

Indeed. Unfortunately the override messages at evaluation time becomes
less informative since it cannot detect from which of the fragments the
duplication/override came from.


> > +# Use the merged file as the starting point for alldefconfig
> > +# (Fills in any missing symbols with Kconfig default)
> > +make KCONFIG_ALLCONFIG=$TMP_FILE alldefconfig
> > +
> > +# Check all specified config values took (might have missed-dependency issues)
> > +cat $TMP_FILE | while read line; do
> > +	CFG=`echo $line | \
> > +		sed 's/^\(# \)\{0,1\}\(CONFIG_[a-zA-Z0-9_]*\)[= ].*/\2/'`
> > +
> > +	REQUESTED_VAL=`grep -w -e "$CFG" $TMP_FILE`
> > +	ACTUAL_VAL=`grep -w -e "$CFG" .config`
> > +	if [ "x$REQUESTED_VAL" != "x$ACTUAL_VAL" ] ; then
> > +		echo "Value requested for $CFG not in final .config"
> > +		echo "Requested value:  $REQUESTED_VAL"
> > +		echo "Actual value:     $ACTUAL_VAL"
> > +		echo ""
> 
> This requested vs. actual diff would be nice to have in kconfig I think.
> The the merge script could be reduced to a simple cat(1) invocation.

I actually started with a simple cat call, but that has limitations:
Specifically when checking what was requested and what took in
the .config, we don't want to flag explicitly overrided values (for
instance in file A: CONFIG_FOO=y, in file B:# CONFIG_FOO is not set, we
don't want to complain that CONFIG_FOO=y isn't set.) That's why we do
the de-duplication first, and then compare the deduplicated input with
the output.

thanks
-john




