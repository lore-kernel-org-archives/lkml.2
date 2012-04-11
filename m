Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760840Ab2DKSsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 14:48:00 -0400
Received: from oyp.chewa.net ([91.121.6.101]:39293 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754346Ab2DKSr7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 14:47:59 -0400
From: "=?utf-8?q?R=C3=A9mi?= Denis-Courmont" <remi@remlab.net>
Organization: Remlab.net
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC] [PATCH] v4l2: use unsigned rather than enums in ioctl() structs
Date: Wed, 11 Apr 2012 21:47:53 +0300
User-Agent: KMail/1.13.7 (Linux/3.3.1-basile; KDE/4.7.4; i686; ; )
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <1333648371-24812-1-git-send-email-remi@remlab.net> <4F85B908.4070404@redhat.com>
In-Reply-To: <4F85B908.4070404@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201204112147.55348.remi@remlab.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hello,

Le mercredi 11 avril 2012 20:02:00 Mauro Carvalho Chehab, vous avez écrit :
> Using unsigned instead of enum is not a good idea, from API POV, as
> unsigned has different sizes on 32 bits and 64 bits.

Fair enough. But then we can do that instead:
typedef XXX __enum_t;
where XXX is the unsigned integer with the right number of bits. Since Linux 
does not use short enums, this ought to work fine.

> Yet, using enum was really a very bad idea, and, on all new stuff,
> we're not accepting any new enum field.

That is unfortunately not true. You do follow that rule for new fields to 
existing V4L2 structure. But you have been royally ignoring that rule when it 
comes to extending existing enumerations:

linux-media does regularly add new enum values to existing enums. That is new 
stuff too, and every single time you do that, you do BREAK THE USERSPACE ABI. 
This is entirely unacceptable and against established kernel development 
policies.

For instance, in Linux 3.1, V4L2_CTRL_TYPE_BITMASK was added. This broke 
userspace. And there are some pending patches adding more of the same thing... 
And V4L2_MEMORY_DMABUF will similarly break the user-to-kernel interface, 
which is yet worse.

> That's said, a patch like that were proposed in the past. See:
> 	http://www.spinics.net/lists/vfl/msg25686.html
> 
> Alan said there [1] that:
> 	"Its a fundamental change to a public structure from enum to u32. I think
> you are right but this change seems too late by several years."

I cannot see how the kernel is protected against userspace injecting error 
values into enums. For all I know, depending how the kernel is compiled, 
userspace might be able to trigger "undefined" behavior in kernel space.

Is it be several years too late to fix a bug?

(...)
> I don't think anything has changed since then that would make it easier
> to apply a change like that.

OK. But then you cannot update extend existing enums... No DMA buffers, no 
integer menu controls...

-- 
Rémi Denis-Courmont
http://www.remlab.net/
http://fi.linkedin.com/in/remidenis
