Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab1DGVh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 17:37:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752450Ab1DGVh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 17:37:26 -0400
Date: Thu, 7 Apr 2011 14:37:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steve Rago <sar@nec-labs.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Allow O_SYNC to be set by fcntl(F_SETFL)
Message-Id: <20110407143719.4044c00d.akpm@linux-foundation.org>
In-Reply-To: <4D6824A4.6030009@nec-labs.com>
References: <4D6824A4.6030009@nec-labs.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(did I ever reply to this?  I meant to ;))

On Fri, 25 Feb 2011 16:52:36 -0500
Steve Rago <sar@nec-labs.com> wrote:

> This has probably been a problem since day 1 (I ran into this running the 2.4 kernel years ago; finally got around to 
> fixing it).  The problem is that fcntl(fd, F_SETFL, flags|O_SYNC) appears to work, but silently ignores the O_SYNC flag. 
>   Opening the file with O_SYNC works okay, but setting it later on via fcntl doesn't work.
> 
> 
> Signed-off-by: Steve Rago <sar@nec-labs.com>
> ---
>   fs/fcntl.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/fcntl.c b/fs/fcntl.c
> index cb10261..afd233a 100644
> --- a/fs/fcntl.c
> +++ b/fs/fcntl.c
> @@ -143,7 +143,7 @@ SYSCALL_DEFINE1(dup, unsigned int, fildes)
>          return ret;
>   }
> 
> -#define SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | O_DIRECT | O_NOATIME)
> +#define SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | O_DIRECT | O_NOATIME | O_SYNC)

Does any standard say that we should do this? 
http://pubs.opengroup.org/onlinepubs/007908799/xsh/fcntl.html does, I
guess.

I worry a bit that this change will surprise people.  For example, this
person:
http://koders.com/c/fidA34D8D5EE9AA5D0AB0F3C604678E2E935E5B0246.aspx?s=dupa
is going to wonder why his app suddenly got a lot slower!

Sadly, the kernel silently ignores invalid set bits in `arg', so we
have no reliable way of signaling to the user that our behaviour here
changed.

I wonder if we should sync the file when someone sets O_SYNC this way. 
If we don't then there is a period during which we have an fd which has
O_SYNC set, but it has pending unwritten data.  An O_SYNC fd should
never be in such a state!

Ho hum.  yes, I guess we should apply the patch.  But it would have
been better to not have screwed this up in the first place!

