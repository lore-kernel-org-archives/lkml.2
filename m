Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab1BBWwL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 17:52:11 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:54471 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab1BBWwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 17:52:09 -0500
From: Andreas Schwab <schwab@linux-m68k.org>
To: Dmitry Torokhov <dtor@vmware.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: Early crash (was: Re: module: show version information for built-in modules in sysfs)
References: <AANLkTin4gOnEMruLDM=TkNYsNf5S370WqbcDVJzT7_Z4@mail.gmail.com>
	<20110201210944.GA12348@dtor-ws.eng.vmware.com>
	<AANLkTimv=KqtuR36dMNa+=OMi0mgd8JK4qsb_SpmKmhs@mail.gmail.com>
	<20110201222637.GA17521@dtor-ws.eng.vmware.com>
	<AANLkTikWVt8NEyHN+=yD4EWSXUQt0gt5nLJtKQDw397M@mail.gmail.com>
	<20110202194227.GA13794@dtor-ws.eng.vmware.com>
X-Yow: ..  If I had heart failure right now, I couldn't be a more fortunate man!!
Date: Wed, 02 Feb 2011 23:52:04 +0100
In-Reply-To: <20110202194227.GA13794@dtor-ws.eng.vmware.com> (Dmitry
	Torokhov's message of "Wed, 2 Feb 2011 11:42:27 -0800")
Message-ID: <m2ipx2dp7v.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov <dtor@vmware.com> writes:

> But why is it aligned on 2-byte boundary and why m64k is not happy with
> module_version_attribute but is happy with kernel_param which is also
> aligned similarly?

struct kernel_parm doesn't contain internal padding on 32 bit
architectures (it does on 64bit architectures though).

> If we unroll module_version_attribute it woud look like this:
>
> struct module_version_attribute {
>
> 	struct module_attribute {
>
> 		struct attribute {
> 			const char *name;
> 			mode_t mode;
> 		} attr;
> 		...
>
> 	} mattr;
>
> 	const char *module_name;
> 	const char *version;
> };
>
> So I would expect it be aligned on (char *) boundary which should be the
> same as (void *).

mode_t is a 16 bit type, thus any following member becomes aligned on an
odd 2 byte boundary.  On 32bit architectures with 4 byte alignment and
16 bit mode_t struct attribute contains 2 bytes of internal padding.
(64bit architectures typically have a 32bit mode_t, and there are 4
bytes of padding.)

> Will it help if we rearrange module_version_attribute definition to
> explicitly have first field being a pointer so it is more like
> kernel_param, like this:
>
> struct module_version_attribute {
> 	const char *module_name;
> 	const char *version;
> 	struct module_attribute mattr;
> };

That won't change the total size of the structure.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
