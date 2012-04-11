Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076Ab2DKUIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 16:08:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761059Ab2DKUIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 16:08:23 -0400
Message-ID: <4F85E4A8.2080506@redhat.com>
Date: Wed, 11 Apr 2012 17:08:08 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: =?UTF-8?B?UsOpbWkgRGVuaXMtQ291cm1vbnQ=?= <remi@remlab.net>
CC: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] [PATCH] v4l2: use unsigned rather than enums in ioctl()
 structs
References: <1333648371-24812-1-git-send-email-remi@remlab.net> <4F85B908.4070404@redhat.com> <201204112147.55348.remi@remlab.net>
In-Reply-To: <201204112147.55348.remi@remlab.net>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 11-04-2012 15:47, Rémi Denis-Courmont escreveu:
> 	Hello,
> 
> Le mercredi 11 avril 2012 20:02:00 Mauro Carvalho Chehab, vous avez écrit :
>> Using unsigned instead of enum is not a good idea, from API POV, as
>> unsigned has different sizes on 32 bits and 64 bits.
> 
> Fair enough. But then we can do that instead:
> typedef XXX __enum_t;
> where XXX is the unsigned integer with the right number of bits. Since Linux 
> does not use short enums, this ought to work fine.

I forgot to comment about that on the last e-mail. 

A solution close to the above one were already proposed:
	http://www.spinics.net/lists/vfl/msg25707.html

There were also another proposal there that might solve:
	http://www.spinics.net/lists/vfl/msg25702.html


Something like:

#if sizeof(enum) == 1
	typedef u8	__enum_t;
#elif sizeof(enum) == 2
	typedef u16	__enum_t;
#elif sizeof(enum) == 4
	typedef u32	__enum_t;
#elif sizeof(enum) == 8
	typedef u64	__enum_t;
#else
	typedef enum __enum_t;
#endif

Can actually work. Not sure if I really like adding a typedef, but maybe
this is the less dirty way to fix it.

We'll need to properly test the v4l2-compat32 code, as it will need 
to handle a different enum size on userspace. So, there, we'll likely
need to replace every enum with just "u32". Hmm... arm with 64 bits
(if/when added) may be an additional issue for the compat stuff.

Regards,
Mauro
