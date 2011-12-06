Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326Ab1LFQKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 11:10:06 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:54646 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750883Ab1LFQKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 11:10:04 -0500
Date: Tue, 6 Dec 2011 11:10:02 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Namjae Jeon <linkinjeon@gmail.com>
cc: akpm@linux-foundation.org, <linux-kernel@vger.kernel.org>,
        Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: Re: [PATCH] nls: add surrogate pair support in nls utf8.
In-Reply-To: <CAKYAXd-c9-UgMsa=VJXkvd7k=jPFZXCmQQZEh6eBiFbDayg6bw@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1112061102270.1469-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Dec 2011, Namjae Jeon wrote:

> > Firstly, have you checked whether the callers of this function expect
> > to receive back more than one 16-bit value?  Maybe you will overrun
> > their buffers by doing this.
> Hi Alan.
> first Thanks for your review.
> yes, you're right. and yes I have checked it on FAT fs,  I will try to
> post the below FAT patch after this patch is applied.

But what about other callers?  Have you checked the entire kernel 
source to see if char2uni is used anywhere else?

> --- a/fs/fat/namei_vfat.c
> +++ b/fs/fat/namei_vfat.c
> @@ -555,7 +555,10 @@ xlate_to_uni(const unsigned char *name, int len,
> unsigned char *outname,
>                                                 return -EINVAL;
>                                         ip += charlen;
>                                         i += charlen;
> -                                       op += 2;
> +                                       if (charlen == sizeof(unicode_t))
> +                                               op += 4;
> +                                       else
> +                                               op += 2;

This seems completely wrong.  The amount you increment the output
pointer doesn't depend on the length of the input character; it depends
on whether the output needed to use a surrogate pair.

Furthermore, it doesn't answer my question.  What happens if _every_
character in the input filename has to be converted to a surrogate 
pair?  Then the output string will be twice as long as xlate_to_uni() 
expects, so it might overrun the output buffer.


> > Secondly, you shouldn't have to make all these changes.  Just call
> > utf8s_to_utf16s(); then all you have to worry about is changing an
> > invalid character to a '?'.
> Currently there are two paths along mount option. if using -o utf8
> mount option, utf8s_to_utf16s have been used in xlate_to_uni of FAT.
> and if using iocharset=utf8, char2uni have been used..
> nls->char2uni works on a single charachter while utf8s_to_utf16s works
> on whole string.
> when the mount option(uni_xlate) that require scanning character by
> character is used it is needed.

That doesn't matter.  The point is that you have duplicated the code in 
nls_base.c, which is a bad idea.  Instead of making a copy of the code, 
you should use the code that is already there.  You may find that the 
easiest way is to add a new utf32_to_utf16 function in nls_base.c.

Alan Stern

