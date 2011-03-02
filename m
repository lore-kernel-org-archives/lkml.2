Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab1CBAab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 19:30:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756617Ab1CBAaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 19:30:30 -0500
Date: Tue, 1 Mar 2011 16:30:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jim Keniston <jkenisto@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] zlib: Slim down zlib_deflate workspace when possible
Message-Id: <20110301163026.f1b5fa56.akpm@linux-foundation.org>
In-Reply-To: <20110228210420.15417.41430.stgit@localhost.localdomain>
References: <20110228210420.15417.41430.stgit@localhost.localdomain>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Feb 2011 13:04:20 -0800
Jim Keniston <jkenisto@us.ibm.com> wrote:

> Instead of always creating a huge (268K) deflate_workspace with the
> maximum compression parameters (windowBits=15, memLevel=8), allow the
> caller to obtain a smaller workspace by specifying smaller parameter
> values -- via zlib_deflate_workspacesize2().
> 
> For example, when capturing oops and panic reports to a medium with
> limited capacity, such as NVRAM, compression may be the only way to
> capture the whole report.  In this case, a small workspace (24K works
> fine) is a win, whether you allocate the workspace when you need it
> (i.e., during an oops or panic) or at boot time.
> 
> I've verified that this patch works with all accepted values of
> windowBits (positive and negative), memLevel, and compression level;
> and also via the existing zlib_deflate_workspacesize() /
> zlib_deflateInit() interface.

zlib_deflate_workspacesize() has seven callsites.  Rather than creating
the new zlib_deflate_workspacesize2() I suggest that you just add the
two new args to zlib_deflate_workspacesize() and then adjust the
existing callers.

> 
> diff --git a/include/linux/zlib.h b/include/linux/zlib.h
> index 40c49cb..3f15036 100644
> --- a/include/linux/zlib.h
> +++ b/include/linux/zlib.h
> @@ -179,11 +179,21 @@ typedef z_stream *z_streamp;
>  
>                          /* basic functions */
>  
> +extern int zlib_deflate_workspacesize2 (int windowBits, int memLevel);
> +/*
> +   Returns the number of bytes that needs to be allocated for a per-
> +   stream workspace with the specified parameters.  A pointer to this
> +   number of bytes should be returned in stream->workspace before
> +   calling zlib_deflateInit2(); and the windowBits and memLevel
> +   parameters passed to zlib_deflateInit2() must not exceed those
> +   passed here.
> +*/

Wait.  The (unspeakably poxy) zlib code puts comments *after* the thing
which they're commenting on?  Who did that and is he bigger than me?

