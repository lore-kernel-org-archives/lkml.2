Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab0KWN6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 08:58:16 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40799 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab0KWN6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 08:58:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=QXaGHCrXlaAc2Z4lC2J+8EcBQwammtEPhoCX/tfBrt5lphHT4JgI10J9WwOfmI1oOL
         J/2bznmVs/YoWGC7yLi8H4vR3NqK+NSabPLCThdPfdSj/L8qxEjSreGDWMzrhKPFrJao
         YQlFophHpmZhFCwCmhicE0y8Pi+7RNA6XkvX4=
Date: Tue, 23 Nov 2010 22:01:11 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        kernel-janitors@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH v2] fs: select: fix information leak to userspace
Message-ID: <20101123140111.GA3816@hack>
References: <1289421483-23907-1-git-send-email-segooon@gmail.com> <20101112120834.33062900.akpm@linux-foundation.org> <8D90F8B2-EA29-4EB9-9807-294CE0D5523B@dilger.ca> <20101114092533.GB5323@albatros> <20101114180643.593d19ac.akpm@linux-foundation.org> <1289848341.2607.125.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1289848341.2607.125.camel@edumazet-laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 08:12:21PM +0100, Eric Dumazet wrote:
>Le dimanche 14 novembre 2010 à 18:06 -0800, Andrew Morton a écrit : 
>> On Sun, 14 Nov 2010 12:25:33 +0300 Vasiliy Kulikov <segoon@openwall.com> wrote:
>> >  
>> >  	if (timeval) {
>> > -		rtv.tv_sec = rts.tv_sec;
>> > -		rtv.tv_usec = rts.tv_nsec / NSEC_PER_USEC;
>> > +		struct timeval rtv = {
>> > +			.tv_sec = rts.tv_sec,
>> > +			.tv_usec = rts.tv_nsec / NSEC_PER_USEC
>> > +		};
>> >  
>> >  		if (!copy_to_user(p, &rtv, sizeof(rtv)))
>> >  			return ret;
>> 
>> Please check the assembly code - this will still leave four bytes of
>> uninitalised stack data in 'rtv', surely.
>
>Thats a good question.
>
>In my understanding, gcc should initialize all holes (and other not
>mentioned fields) with 0, even for automatic storage [C99 only mandates
>this on static storage]
>
>I tested on x86_64 and this is the case, but could not find a definitive
>answer in gcc documentation.
>

Yeah, this is not clearly defined by C99 I think, but we can still
find some clues in 6.2.6.1, Paragraph 6,

"
When a value is stored in an object of structure or union type,
including in a member object, the bytes of the object representation
that correspond to any padding bytes take unspecified values.
"

So we can't rely on the compiler to initialize the padding bytes
too.

-- 
Live like a child, think like the god.
 
