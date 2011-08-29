Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab1H2Pl3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 11:41:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753791Ab1H2Pl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 11:41:26 -0400
Date: Mon, 29 Aug 2011 11:40:41 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH][Trivial] CIFS: Don't free volume_info->UNC until we are
 entirely done with it.
Message-ID: <20110829114041.6c1a0a4e@tlielax.poochiereds.net>
In-Reply-To: <alpine.LNX.2.00.1108271851470.27813@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1108271851470.27813@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Aug 2011 18:58:34 +0200 (CEST)
Jesper Juhl <jj@chaosbits.net> wrote:

> In cleanup_volume_info_contents() we kfree(volume_info->UNC); and then 
> proceed to use that variable on the very next line.
> This causes (at least) Coverity Prevent to complain about use-after-free 
> of that variable (and I guess other checkers may do that as well).
> There's not any /real/ problem here since we are just using the value of 
> the pointer, not actually dereferencing it, but it's still trivial to 
> silence the tool, so why not?
> To me at least it also just seems nicer to defer freeing the variable 
> until we are entirely done with it in all respects.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  fs/cifs/connect.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 633c246..9bb4b10 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2877,9 +2877,9 @@ cleanup_volume_info_contents(struct smb_vol *volume_info)
>  {
>  	kfree(volume_info->username);
>  	kzfree(volume_info->password);
> -	kfree(volume_info->UNC);
>  	if (volume_info->UNCip != volume_info->UNC + 2)
>  		kfree(volume_info->UNCip);
> +	kfree(volume_info->UNC);
>  	kfree(volume_info->domainname);
>  	kfree(volume_info->iocharset);
>  	kfree(volume_info->prepath);

Seems reasonable for silencing the checker...

Reviewed-by: Jeff Layton <jlayton@redhat.com>
