Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab1IDAho (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 20:37:44 -0400
Received: from nm14-vm0.bullet.mail.ird.yahoo.com ([77.238.189.193]:34344 "HELO
	nm14-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751140Ab1IDAhn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 20:37:43 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 873063.57336.bm@omp1013.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=jn1haVDAfrbO2gupBwPwzigGjQrERwhelnw0jJ51uofzjLIP8+dDG8VXfER6rQY6F2ZK+CPUtKPK8wocVznApYDgKTKoBN2LJZPzsVtKXB57P+Sw62kvgtmd49lrEUOOsEqnPMYl2De1JlcUX/ApIDXf3fiGgZOydilpJITB2qQ=;
X-YMail-OSG: fMZWMy4VM1kPQmL1nvYPXbTOTTT4xD7GYT6EW5m.cNnekvc
 ZOQhE7GNyd.xDm70BWx7eZYxqKZ3LHxjA.37pjF.iEwstxCc8XJz71QO_Svq
 Wnqncv.g.5nyCNpOJR6tvhdEqCbFaovIaDdbcDH8y6jR_Hyd3S68QlO7wUkX
 SSElhEirDcjjyl80PIasbUQdnwh7wntEEWu.gwrYQT3EphoP5kXbO0Dp7NSG
 dprzA1xiahnH86DhwPyGrafPostDjFoR7G5l_ZmUrcyhQvkN_4pCwv3jCts0
 zy6Hdt0V0TC3vEIS4lB7nhu64oe8ip1BH0CZOBHG8KAmUFE307tOs.nNxp99
 qb476iB2bORLrjn23.9i3zfU2ZrzyaPu0n_bpaigZa8EK4BHZ6OlWef249NS
 yQEEwl8JViltaZege5zDf
X-Mailer: YahooMailClassic/14.0.5 YahooMailWebService/0.8.113.315625
Message-ID: <1315096661.23425.YahooMailClassic@web29510.mail.ird.yahoo.com>
Date: Sun, 4 Sep 2011 01:37:41 +0100 (BST)
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Subject: Re: Kernel 3.1.0-rc4 oops when connecting iPod
To: Pavel Ivanov <paivanof@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <CAG1a4rscDrbiCKxSPvbkG7SutQ5HCU2tX9FJEv81nFuVxLWekg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Sun, 4/9/11, Pavel Ivanov <paivanof@gmail.com> wrote:

> On Sat, Sep 3, 2011 at 7:35 PM,
> >> So these 2 pointers are exactly what causing the
> trouble.
> >
> > This is interesting... so it would appear that
> hfsplus_read_wrapper() isn't working correctly, but enough
> of correct information to pass checks. I just re-read your
> e-mail and your device has a logical block size of 4096
> bytes, whereas most of the hfsplus code uses a block size of
> 512... you will need to look into hfsplus_submit_bio(),
> which is in the same file wrapper.c.
> 
> I've looked into the code myself a little and here's what I
> see.
> hfsplus_read_wrapper() calls to hfsplus_submit_bio() twice
> to fill
> sbi->s_vhdr and sbi->s_backup_vhdr. And according to
> parameters they
> are filled with pointers into sbi->s_vhdr_buf and
> sbi->s_backup_vhdr_buf respectively. It's done with the
> following code
> at fs/hfsplus/wrapper.c:79:
> 
>     if (!(rw & WRITE) && data)
>         *data = (u8 *)buf +
> offset;
> 
> So s_vhdr and s_backup_vhdr shouldn't be freed, s_vhdr_buf
> and
> s_backup_vhdr_buf should be freed instead. And indeed
> changing in
> hfsplus_fill_super()
> 
>     kfree(sbi->s_vhdr);
>     kfree(sbi->s_backup_vhdr);
> 
> to
> 
>     kfree(sbi->s_vhdr_buf);
>     kfree(sbi->s_backup_vhdr_buf);
> 
> fixes BUG reports from SLUB.

The code around there is a bit too dense, and both of the *_buf are recent introductions (and temp values, I think) as is hfsplus_submit_bio() itself, around the 2.6.39/3.0 time frame. I think the intention is to fill s_vhdr/s_backup_vhdr via mulitple fetches using *_buf as temp buffer.

> Now, the problem with "too large" error is trickier.
> According to this message
> 
> >> [   92.549197] hfs: filesystem size too large
> blksz_shift=14, total_blocks=486494
> 
> HFS thinks that my iPod has block size of 16 KiB. But
> generic_check_addressable() decides that everything with
> blocks larger
> than PAGE_CACHE_SHIFT (i.e. 4 KiB on my system) cannot be
> addressable
> and thus filesystem cannot be mounted. I guess it wasn't
> supposed to
> be that way. Is hfsplus_read_wrapper() wrong in determining
> block size
> or all iPods where this was tested actually had block size
> 4 KiB or
> less?

Your logical sector size is 4k according to dmesg and hfs block size is 512 so that 16KiB is a bit dodgy.

> > It is going to be difficult to do anything without the
> actual device and 8GB is too large to be send around.
> Assuming it is mostly music/media and there isn't too much
> stuff which is too confident/private, can I ask you to send
> me say, the first few MB of the disk?
> 
> I'll send it in a separate email bypassing lists.

Thanks - I got them now. It will take a while to find my way around though...
