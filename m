Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab0JTP71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 11:59:27 -0400
Received: from mail.perches.com ([173.55.12.10]:3308 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129Ab0JTP70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 11:59:26 -0400
Subject: Re: [PATCH] drivers/hwmon: Use pr_fmt and pr_<level>
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Hans de Goede <j.w.r.degoede@hhs.nl>,
        Alistair John Strachan <alistair@devzero.co.uk>,
        Henrik Rydberg <rydberg@euromail.se>,
        "Mark M. Hoffman" <mhoffman@lightlink.com>,
        Luca Tettamanti <kronos.it@gmail.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Juerg Haefliger <juergh@gmail.com>,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Jim Cromie <jim.cromie@gmail.com>,
        Roger Lucas <vt8231@hiddenengine.co.uk>, lm-sensors@lm-sensors.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101020094208.3136b9dd@endymion.delvare>
References: <1287530020.10409.594.camel@Joe-Laptop>
	 <20101020094208.3136b9dd@endymion.delvare>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Oct 2010 08:59:23 -0700
Message-ID: <1287590363.1813.148.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 09:42 +0200, Jean Delvare wrote:
> It looks odd that every driver would have to set this. Shouldn't this
> be the default set in <linux/kernel.h>?

http://lkml.org/lkml/2009/10/4/198
http://lkml.org/lkml/2009/10/5/215

I'd prefer something like that as well, and it is
a long-term goal I have, but not yet, no.

There are many files that use pr_<level> without pr_fmt.

Those need to be sorted out first, perhaps by adding a new
line to each of those files to "#define pr_fmt(fmt) fmt"

KBUILD_MODNAME is always #defined by the make system.

$ grep -rP --include=*.[ch] -lw "pr_(info|warn|warning|notice|debug|dbg|vdbg|crit|alert|err|emerg|cont)" * | \
	while read file ; do \
		grep -lwq pr_fmt $file ; \
		echo "$?:$file"; \
	done | \
 cut -f1 -d":" | sort | uniq -c 
    335 0
   1532 1

Exit status 0 means a match for pr_fmt.

So there are ~1900 files that use pr_<level>
in the kernel tree, only 335 have pr_fmt.

This search does have some false negatives because
some files use an #include that does a #define pr_fmt.

Anyway, I'd like to sort it out eventually.
For now, I just add the #define pr_fmt, with
a long term goal of removing them all and using
a different mechanism to remove the duplicated
prefix string altogether from the formats and
save some text.


