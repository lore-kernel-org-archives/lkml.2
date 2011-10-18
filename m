Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab1JRBnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 21:43:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60366 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143Ab1JRBnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 21:43:45 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1110171832060.13515@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1110171752300.19024@chino.kir.corp.google.com>
 <CA+55aFxj+heCCoQx0ecVyCE0b5e3fGpAUPSUH8K7E=TyRzNSUg@mail.gmail.com> <alpine.DEB.2.00.1110171832060.13515@chino.kir.corp.google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 17 Oct 2011 18:43:24 -0700
X-Google-Sender-Auth: MB8MMtPFm7kJx1vNhBCt1oyARWU
Message-ID: <CA+55aFzc5TbNGVAnp42BywWe8_=k8o98-DPnLhzrgN2DMWpbdg@mail.gmail.com>
Subject: Re: [patch] Avoid using hardcoded values in kernel/sys.c
To: David Rientjes <rientjes@google.com>
Cc: Henrik Grindal Bakken <henribak@cisco.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 6:33 PM, David Rientjes <rientjes@google.com> wrote:
>
> Right, I meant to pass the struct in and use sizeof(release->name), but I
> was under the impression that wouldn't count as a variable length array or
> be compiled as such by ISO99 standards because it's a constant expression
> (as the standard says is not variable length).

Yes, if it really were a constant expression of a valid length, that
would be fine. Passing in the struct itself would work, and then you
could do a sizeof of the array, instead of of the pointer to the
character array..

Except in this case it won't work. Because sometimes the struct is the
old one, sometimes it's the new one. So there is no well-defined
struct pointer to pass in. You can only pass in pointer-to-char and
the (variable) size.

Which is why it now just hardcodes it to 65, which is the largest
size. Not exactly "pretty", no. But no worse than using the variable
length array.

Yeah, there are tricks we could play. For example, we could turn that
override_release() into a macro that allocates the array in the
*caller*, where the length is known at compile time, and then pass in
that temporary pointer too. I considered it, but it seemed to be too
much work for too trivial a case. It's not like there are all that
many definitions of utsname, and they are all in <linux/utsname.h>.
It's unlikely that we'd ever add any bigger cases, but if we do, we'd
need to update the constant.

                        Linus
