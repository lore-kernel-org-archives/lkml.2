Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750Ab1CEFVi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 00:21:38 -0500
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:45524 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab1CEFVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 00:21:37 -0500
Date: Sat, 5 Mar 2011 06:21:31 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: chenliu@asset.uwaterloo.ca
Cc: schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2]early: fix possible overlapping data buffer
Message-ID: <20110305052131.GA2687@osiris.boeblingen.de.ibm.com>
References: <20110304151011.GA30600@asset.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110304151011.GA30600@asset.uwaterloo.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 10:10:11AM -0500, chenliu@asset.uwaterloo.ca wrote:
> This patch fixes bugzilla #12965:
> https://bugzilla.kernel.org/show_bug.cgi?id=12965
> 
> The original code contains dangerous uses of sprintf functions like
> sprintf(defsys_cmd, "%s EW MINSIZE=%.7iK PARMREGS=0-13", defsys_cmd, min_size),
> where defsys_cmd is defined as a fixed length buffer. Replace them with
> snprintf can fix such issues.
> 
> Signed-off-by: Chen Liu <chenliunju@gmail.com>
> ---
>  arch/s390/kernel/early.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
> 
> --- a/arch/s390/kernel/early.c
> +++ b/arch/s390/kernel/early.c
> @@ -133,8 +133,8 @@ static noinline __init void create_kerne
>  		sinitrd_pfn = PFN_DOWN(__pa(INITRD_START));
>  		einitrd_pfn = PFN_UP(__pa(INITRD_START + INITRD_SIZE));
>  		min_size = einitrd_pfn << 2;
> -		sprintf(defsys_cmd, "%s EW %.5X-%.5X", defsys_cmd,
> -		sinitrd_pfn, einitrd_pfn);
> +		snprintf(defsys_cmd, sizeof(defsys_cmd), "%s EW %.5X-%.5X",
> +			 defsys_cmd, sinitrd_pfn, einitrd_pfn);
>  	}
>  #endif

This is not the right fix for the bugzilla. What is complained about is that
defsys_cmd is used both as input string as well as output string.
The result in this case is not really defined since all input strings must
be of type const char *, which in this case is obviously not true.
It just happens to work because the format string consumes the input string
first.
Right fix would be to remember the written bytes of the previous sprintf to
the string and use that as offset when adding something.
In _addition_ all sprintfs could be converted to snprintfs as well.
