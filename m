Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234Ab2CFB4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 20:56:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:24558 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758110Ab2CFB4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 20:56:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="118011329"
Subject: Re: [linux-pm] [PATCH V3] cpuidle: Add a sysfs entry to disable
 specific C state for debug purpose.
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Reply-To: yanmin_zhang@linux.intel.com
To: "Valentin, Eduardo" <eduardo.valentin@ti.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        ShuoX Liu <shuox.liu@intel.com>, "Brown, Len" <len.brown@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, greg@kroah.com
In-Reply-To: <CAGF5oy_BUytjeDa8Oc62pRabaEqwqKCFuVJuzLd-XNZg34ne2w@mail.gmail.com>
References: <C6CB66606345BC4B80CBE69D22ABFBB1021C7F@SHSMSX101.ccr.corp.intel.com>
	 <1330647453.1916.7.camel@ymzhang>
	 <20120302142303.648285a7.akpm@linux-foundation.org>
	 <C6CB66606345BC4B80CBE69D22ABFBB10220E1@SHSMSX101.ccr.corp.intel.com>
	 <4F545A4E.8010801@linux.vnet.ibm.com> <4F5466C4.2090808@intel.com>
	 <20120305101827.GA19408@khazad-dum.debian.net>
	 <CAGF5oy_BUytjeDa8Oc62pRabaEqwqKCFuVJuzLd-XNZg34ne2w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: UMG
Date: Tue, 06 Mar 2012 09:54:45 +0800
Message-ID: <1330998885.1916.89.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-05 at 14:20 +0200, Valentin, Eduardo wrote:
> Hello,
> 
> 
> On Mon, Mar 5, 2012 at 12:18 PM, Henrique de Moraes Holschuh
> <hmh@hmh.eng.br> wrote:
> > On Mon, 05 Mar 2012, ShuoX Liu wrote:
> >> @@ -45,6 +46,7 @@ total 0
> >>  /sys/devices/system/cpu/cpu0/cpuidle/state1:
> >>  total 0
> >>  -r--r--r-- 1 root root 4096 Feb  8 10:42 desc
> >> +-rw-r--r-- 1 root root 4096 Feb  8 10:42 disable
> >>  -r--r--r-- 1 root root 4096 Feb  8 10:42 latency
> >>  -r--r--r-- 1 root root 4096 Feb  8 10:42 name
> >>  -r--r--r-- 1 root root 4096 Feb  8 10:42 power
> >
> > ...
> >
> >> diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
> >> index 3fe41fe..1eae29a 100644
> >> --- a/drivers/cpuidle/sysfs.c
> >> +++ b/drivers/cpuidle/sysfs.c
> >> @@ -222,6 +222,9 @@ struct cpuidle_state_attr {
> >>  #define define_one_state_ro(_name, show) \
> >>  static struct cpuidle_state_attr attr_##_name = __ATTR(_name, 0444,
> >> show, NULL)
> >>
> >> +#define define_one_state_rw(_name, show, store) \
> >> +static struct cpuidle_state_attr attr_##_name = __ATTR(_name, 0644,
> >> show, store)
> >> +
> >>  #define define_show_state_function(_name) \
> >>  static ssize_t show_state_##_name(struct cpuidle_state *state, \
> >>                        struct cpuidle_state_usage *state_usage, char *buf) \
> >> @@ -229,6 +232,19 @@ static ssize_t show_state_##_name(struct
> >> cpuidle_state *state, \
> >>       return sprintf(buf, "%u\n", state->_name);\
> >>  }
> >>
> >> +#define define_store_state_function(_name) \
> >> +static ssize_t store_state_##_name(struct cpuidle_state *state, \
> >> +             const char *buf, size_t size) \
> >> +{ \
> >> +     int value; \
> >> +     sscanf(buf, "%d", &value); \
> >> +     if (value) \
> >> +             state->disable = 1; \
> >> +     else \
> >> +             state->disable = 0; \
> >> +     return size; \
> >> +}
> >
> > Isn't this missing a check for capabilities?  Disabling cpuidle states is
> > not something random Joe (and IMHO that does mean random capability-
> > restricted Joe root) should be doing...
> >
> > Also, maybe it would be best to use one of the lib helpers to parse that
> > value, so that it will be less annoying to userspace (trim blanks, complain
> > if there is trailing junk after trimming, etc)?
> 
> I may be jumping the thread in the middle but, if it is for debug
> purposes, as states the subject, shouldn't this entry go to debugfs
> instead of sysfs? I know cpuidle has all the infrastructure there to
> simply add another sysfs entry, but if the intent is to create a debug
> capability, then I'd say it fits under debugfs instead.  Adding Greg
> KH here, as I suppose he may have strong opinion on using sysfs for
> debugging.
Thanks for the comments.

IMHO, all entries under cpuidle directory are for debug purpose. End users
shouldn't care about them. If we rewrite codes around all the entries, I strongly
agree that we need move them to debugfs.

Here, we just add a new entry under same directory. If we create it under debugfs,
we need create the similar directory tree, which is a duplicate effort. In addition,
users might be confused that why we separate the entries under sysfs and debugfs.

> 
> Of course, if you are targeting user space control over C states on
> production  systems, then it's a different thing then.
Although we say it's mostly for debug purpose used by developers, end users could
use it on production systems. For example, they might get a new machine and installed
an official Linux OS on it. They could do some tuning without recompiling the kernel
when recompiling is impossible.


