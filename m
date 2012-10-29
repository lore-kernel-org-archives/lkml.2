Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761556Ab2J2XvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 19:51:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:46814 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761364Ab2J2XvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 19:51:12 -0400
Date: Tue, 30 Oct 2012 00:51:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tvrtko Ursulin <tvrtko@ursulin.net>
cc: Milan Broz <gmazyland@gmail.com>, dm-crypt@saout.de,
        linux-kernel@vger.kernel.org, okozina@redhat.com,
        linux-rt-users@vger.kernel.org
Subject: Re: [dm-crypt] cryptsetup not working under 3.6 - RT patch set seem
 to break it
In-Reply-To: <508EEAF2.4090506@ursulin.net>
Message-ID: <alpine.LFD.2.02.1210300040000.2756@ionos>
References: <50830D33.5050807@ursulin.net> <5083C61C.5090807@gmail.com> <5083E4A8.3060501@ursulin.net> <5083E87B.2080908@gmail.com> <5083EC61.8070505@ursulin.net> <50844D01.9090805@gmail.com> <5084551E.5040304@ursulin.net> <508ED985.5060301@ursulin.net>
 <508EDD6E.7030908@gmail.com> <508EE395.9010709@ursulin.net> <508EEAF2.4090506@ursulin.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2012, Tvrtko Ursulin wrote:
> On 29/10/12 20:14, Tvrtko Ursulin wrote:
> > Unless RT patchset is the culprit. Hm.. that would be unexpected, but I
> > guess it is worth a shot. I'll let you know what happens without -rt.
> 
> Ha, this is exciting, vanilla 3.6.4 works, with -rt10 patch it does not.
> 
> Copying in linux-rt-users.
> 
> To recap, 3.6 RT seems to break dm-crypt. Try it like this:
> 
> cryptsetup --debug --key-file=- luksOpen /some/luks/formatted/file any-label
> 
> And kernel will fail like this:
> 
> Kernel says this:
>      device-mapper: table: 252:1: crypt: Error allocating crypto tfm
>      device-mapper: ioctl: error adding target to table
> 
> I think crypto modules are not getting auto loaded for some reason, but even
> if I load them manually before hand and still breaks in the same way.

I don't think it's a module problem. That code is not very helpful due
to _NOT_ showing the error number so it's hard to decode what actually
fails.

I put this on my todo list, but TBH it's low on my radar. If you are
interested then try to capture the failure with the function
tracer. Put a tracing_off() call into the failure code path, i.e.:

        ret = crypt_alloc_tfms(cc, cipher_api);
        if (ret < 0) {
+	   	tracing_off();
                ti->error = "Error allocating crypto tfm";
		        goto bad;
	}

Enable the function tracer before doing the cryptsetup invocation and
after that read out the trace, compress it and put it somewhere to
download or send it to me in private mail if you don't have a place to
put it.

I can decode the trace, but I don't have the capacity at the moment to
setup all the necessary stuff here and do the debugging myself.

Thanks,

	tglx

