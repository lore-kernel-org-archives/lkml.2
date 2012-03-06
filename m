Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030821Ab2CFOqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 09:46:30 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:43509 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757893Ab2CFOq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 09:46:28 -0500
X-Sasl-enc: RUjOMoll+gsqnr9by7YNnq9O4Ep3EZZZKeyY6ws179Kr 1331045162
Date: Tue, 6 Mar 2012 06:39:35 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Cc: "Valentin, Eduardo" <eduardo.valentin@ti.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        ShuoX Liu <shuox.liu@intel.com>, "Brown, Len" <len.brown@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, andi.kleen@intel.com
Subject: Re: [linux-pm] [PATCH V3] cpuidle: Add a sysfs entry to disable
 specific C state for debug purpose.
Message-ID: <20120306143935.GA23346@kroah.com>
References: <1330647453.1916.7.camel@ymzhang>
 <20120302142303.648285a7.akpm@linux-foundation.org>
 <C6CB66606345BC4B80CBE69D22ABFBB10220E1@SHSMSX101.ccr.corp.intel.com>
 <4F545A4E.8010801@linux.vnet.ibm.com>
 <4F5466C4.2090808@intel.com>
 <20120305101827.GA19408@khazad-dum.debian.net>
 <CAGF5oy_BUytjeDa8Oc62pRabaEqwqKCFuVJuzLd-XNZg34ne2w@mail.gmail.com>
 <1330998885.1916.89.camel@ymzhang>
 <20120306052236.GA19416@kroah.com>
 <1331013078.1916.103.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331013078.1916.103.camel@ymzhang>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 01:51:18PM +0800, Yanmin Zhang wrote:
> On Mon, 2012-03-05 at 21:22 -0800, Greg KH wrote:
> > On Tue, Mar 06, 2012 at 09:54:45AM +0800, Yanmin Zhang wrote:
> > > On Mon, 2012-03-05 at 14:20 +0200, Valentin, Eduardo wrote:
> > > > Hello,
> > > > 
> > > > 
> > > > On Mon, Mar 5, 2012 at 12:18 PM, Henrique de Moraes Holschuh
> > > > <hmh@hmh.eng.br> wrote:
> > > > > On Mon, 05 Mar 2012, ShuoX Liu wrote:
> > > > >> @@ -45,6 +46,7 @@ total 0
> > > > >>  /sys/devices/system/cpu/cpu0/cpuidle/state1:
> > > > >>  total 0
> > > > >>  -r--r--r-- 1 root root 4096 Feb  8 10:42 desc
> > > > >> +-rw-r--r-- 1 root root 4096 Feb  8 10:42 disable
> > > > >>  -r--r--r-- 1 root root 4096 Feb  8 10:42 latency
> > > > >>  -r--r--r-- 1 root root 4096 Feb  8 10:42 name
> > > > >>  -r--r--r-- 1 root root 4096 Feb  8 10:42 power
> > > > >
> > > > > ...
> > > > >
> > > > >> diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
> > > > >> index 3fe41fe..1eae29a 100644
> > > > >> --- a/drivers/cpuidle/sysfs.c
> > > > >> +++ b/drivers/cpuidle/sysfs.c
> > > > >> @@ -222,6 +222,9 @@ struct cpuidle_state_attr {
> > > > >>  #define define_one_state_ro(_name, show) \
> > > > >>  static struct cpuidle_state_attr attr_##_name = __ATTR(_name, 0444,
> > > > >> show, NULL)
> > > > >>
> > > > >> +#define define_one_state_rw(_name, show, store) \
> > > > >> +static struct cpuidle_state_attr attr_##_name = __ATTR(_name, 0644,
> > > > >> show, store)
> > > > >> +
> > > > >>  #define define_show_state_function(_name) \
> > > > >>  static ssize_t show_state_##_name(struct cpuidle_state *state, \
> > > > >>                        struct cpuidle_state_usage *state_usage, char *buf) \
> > > > >> @@ -229,6 +232,19 @@ static ssize_t show_state_##_name(struct
> > > > >> cpuidle_state *state, \
> > > > >>       return sprintf(buf, "%u\n", state->_name);\
> > > > >>  }
> > > > >>
> > > > >> +#define define_store_state_function(_name) \
> > > > >> +static ssize_t store_state_##_name(struct cpuidle_state *state, \
> > > > >> +             const char *buf, size_t size) \
> > > > >> +{ \
> > > > >> +     int value; \
> > > > >> +     sscanf(buf, "%d", &value); \
> > > > >> +     if (value) \
> > > > >> +             state->disable = 1; \
> > > > >> +     else \
> > > > >> +             state->disable = 0; \
> > > > >> +     return size; \
> > > > >> +}
> > > > >
> > > > > Isn't this missing a check for capabilities?  Disabling cpuidle states is
> > > > > not something random Joe (and IMHO that does mean random capability-
> > > > > restricted Joe root) should be doing...
> > > > >
> > > > > Also, maybe it would be best to use one of the lib helpers to parse that
> > > > > value, so that it will be less annoying to userspace (trim blanks, complain
> > > > > if there is trailing junk after trimming, etc)?
> > > > 
> > > > I may be jumping the thread in the middle but, if it is for debug
> > > > purposes, as states the subject, shouldn't this entry go to debugfs
> > > > instead of sysfs? I know cpuidle has all the infrastructure there to
> > > > simply add another sysfs entry, but if the intent is to create a debug
> > > > capability, then I'd say it fits under debugfs instead.  Adding Greg
> > > > KH here, as I suppose he may have strong opinion on using sysfs for
> > > > debugging.
> > > Thanks for the comments.
> > > 
> > > IMHO, all entries under cpuidle directory are for debug purpose. End users
> > > shouldn't care about them. If we rewrite codes around all the entries, I strongly
> > > agree that we need move them to debugfs.
> > 
> > I totally agree, they all need to move out of sysfs.
> > 
> > > Here, we just add a new entry under same directory. If we create it under debugfs,
> > > we need create the similar directory tree, which is a duplicate effort. In addition,
> > > users might be confused that why we separate the entries under sysfs and debugfs.
> > 
> > They should all be moved there, that will remove any confusion :)
> Greg,
> 
> Sorry. I might mislead you.
> 
> Basically, we could move all the entries of cpuidle from sysfs to debugfs. But such
> moving would change KBI. There might be many scripts used by end users to parse the
> data. If we change them to debugfs, the scripts wouldn't work and users would
> complain.
> 
> What's your opinion about the KBI consistence?

These files all are debugging files, right?  So they should be moved,
especially as the violate the "one value per file" rule of sysfs.

Do you know of any tools using these files?  I have never heard of them,
and I was told we should move these files years ago.  So I don't think
there should be any api issues.

But, if there are, we need to know what they are, and work to preserve
them.  The only way to find out is to move them :)

thanks,

greg k-h
