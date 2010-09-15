Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab0IOPMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 11:12:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753928Ab0IOPMT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 11:12:19 -0400
MIME-Version: 1.0
In-Reply-To: <20100915104855.41de3ebf@lilo>
References: <20100915104855.41de3ebf@lilo>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 15 Sep 2010 08:11:16 -0700
Message-ID: <AANLkTimNsDxeyZL4GVaH4L7YGO-EoRyCMHDtMPWU37hN@mail.gmail.com>
Subject: Re: [RFC][PATCH] Cross Memory Attach
To: Christopher Yeoh <cyeoh@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 6:18 PM, Christopher Yeoh <cyeoh@au1.ibm.com> wrote:
> +
> +               if (copy_to) {
> +                       ret = copy_from_user(target_kaddr,
> +                                            user_buf + *bytes_copied,
> +                                            bytes_to_copy);
> +                       if (ret) {
> +                               kunmap(process_pages[i]);
> +                               goto end;
> +                       }
> +               } else {
> +                       ret = copy_to_user(user_buf + *bytes_copied,
> +                                          target_kaddr, bytes_to_copy);
> +                       if (ret) {
> +                               kunmap(process_pages[i]);
> +                               goto end;
> +                       }
> +               }
> +               kunmap(process_pages[i]);

Btw, please just do this as

   if (copy_to)
      ret = copy_from_user(..);
   else
      ret = copy_to_user(..);
   kunmap(process_pages[i]);
   if (ret)
      goto out;

(and also, I think you should probably use a real variable for
*bytes_copied, rather than update things behind the pointer. Update
the pointer just once at the end instead, or preferably just change
the calling convention to just return the number of bytes copied, and
let the caller do the page counting).

                      Linus
