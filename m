Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab1I0DaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 23:30:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:9576 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549Ab1I0DaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 23:30:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="56179977"
Message-ID: <4E814345.2070102@linux.intel.com>
Date: Mon, 26 Sep 2011 20:30:13 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Darren Hart <dvhart@linux.intel.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Dmitry Fink <Dmitry.Fink@palm.com>
Subject: Re: [PATCH 1/2] merge_config.sh: do not print non-matching lines
 in the sed expressions
References: <1316582561-23066-1-git-send-email-john.stultz@linaro.org> <1317093949-20219-1-git-send-email-dvhart@linux.intel.com> <a3c278930a1995e5c78486a20763a1ec780f63c4.1317093857.git.dvhart@linux.intel.com>
In-Reply-To: <a3c278930a1995e5c78486a20763a1ec780f63c4.1317093857.git.dvhart@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2011 08:25 PM, Darren Hart wrote:
> The script picks up on comment lines and run into failed grep commands and
> spew lots of warnings about "#" not being set and so forth.
> 
> sed will print non-matching lines without the -n option. Add -n and a p (print)
> to each sed command. This will ensure only the CONFIG_* lines are used for
> value comparison, and comment lines are ignored. # CONFIG_XYZ is not set are
> still matched and not treated as comments. This addresses an issue Dmitry raised
> without another pipe and call to grep.
> 
> Move the sed expression into a variable to avoid getting the regular expressions
> in the two call sites out of sync.
> 
> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> CC: Dmitry Fink <Dmitry.Fink@palm.com>
> ---
>  scripts/kconfig/merge_config.sh |   10 ++++------
>  1 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/scripts/kconfig/merge_config.sh b/scripts/kconfig/merge_config.sh
> index fda0139..a644724 100755
> --- a/scripts/kconfig/merge_config.sh
> +++ b/scripts/kconfig/merge_config.sh
> @@ -25,11 +25,12 @@ MERGE_LIST=$*
>  
>  TMP_FILE=$(mktemp ./.tmp.config.XXXXXXXXXX)
>  
> +SED_CONFIG_EXP="s/^\(# \)\{0,1\}\(CONFIG_[a-zA-Z0-9_]*\)[= ].*/\2/p"
> +
>  # Merge files, printing warnings on overrided values
>  for MERGE_FILE in $MERGE_LIST ; do
>  	echo "Merging $MERGE_FILE"
> -	CFG_LIST=`cat $MERGE_FILE | \
> -	  sed 's/^\(# \)\{0,1\}\(CONFIG_[a-zA-Z0-9_]*\)[= ].*/\2/'`
> +	CFG_LIST=`cat $MERGE_FILE | sed -n "$SED_CONFIG_EXP"`

Gah, and this doesn't need the cat either:

        CFG_LIST=`sed -n "$SED_CONFIG_EXP" $MERGE_FILE`

--
Darren

>  	for CFG in $CFG_LIST ; do
>  		grep -q -w $CFG $TMP_FILE
>  		if [ $? == 0 ] ; then
> @@ -53,10 +54,7 @@ done
>  make KCONFIG_ALLCONFIG=$TMP_FILE alldefconfig
>  
>  # Check all specified config values took (might have missed-dependency issues)
> -cat $TMP_FILE | while read line; do
> -	CFG=`echo $line | \
> -		sed 's/^\(# \)\{0,1\}\(CONFIG_[a-zA-Z0-9_]*\)[= ].*/\2/'`
> -
> +for CFG in `sed -n "$SED_CONFIG_EXP" $TMP_FILE`; do
>  	REQUESTED_VAL=`grep -w -e "$CFG" $TMP_FILE`
>  	ACTUAL_VAL=`grep -w -e "$CFG" .config`
>  	if [ "x$REQUESTED_VAL" != "x$ACTUAL_VAL" ] ; then

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
