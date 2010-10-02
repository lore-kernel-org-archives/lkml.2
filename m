Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab0JBD1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 23:27:20 -0400
Received: from in.cluded.net ([195.159.98.120]:36219 "EHLO in.cluded.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184Ab0JBD1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 23:27:18 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Oct 2010 23:27:18 EDT
Message-ID: <4CA6A484.8000109@uw.no>
Date: Sat, 02 Oct 2010 03:18:28 +0000
From: "Daniel K." <dk@uw.no>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9a1) Gecko/20060307 SeaMonkey/1.5a
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH RESEND v3 09/24] ptrace: cleanup arch_ptrace() on frv
References: <1285838880-4977-1-git-send-email-namhyung@gmail.com> <1285838880-4977-10-git-send-email-namhyung@gmail.com>
In-Reply-To: <1285838880-4977-10-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namhyung Kim wrote:
> Use new 'regno', 'datap' variables in order to remove duplicated
> expressions and unnecessary castings. Alse remove checking @addr
> less than 0 because addr is now unsigned.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: David Howells <dhowells@redhat.com>
> ---
>  arch/frv/kernel/ptrace.c |   29 +++++++++++++----------------
>  1 files changed, 13 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/frv/kernel/ptrace.c b/arch/frv/kernel/ptrace.c
> index e9dbfad..9d68f7f 100644
> --- a/arch/frv/kernel/ptrace.c
> +++ b/arch/frv/kernel/ptrace.c
> @@ -259,19 +259,21 @@ long arch_ptrace(struct task_struct *child, long request,
>  {
>  	unsigned long tmp;
>  	int ret;
> +	int regno = addr >> 2;
> +	unsigned long __user *datap = (unsigned long __user *) data;
>  
>  	switch (request) {
>  		/* read the word at location addr in the USER area. */
>  	case PTRACE_PEEKUSR: {
>  		tmp = 0;
>  		ret = -EIO;
> -		if ((addr & 3) || addr < 0)
> +		if (addr & 3)
>  			break;
>  
>  		ret = 0;
> -		switch (addr >> 2) {
> +		switch (regno) {
>  		case 0 ... PT__END - 1:
> -			tmp = get_reg(child, addr >> 2);
> +			tmp = get_reg(child, regno);
>  			break;
>  
>  		case PT__END + 0:
> @@ -300,23 +302,18 @@ long arch_ptrace(struct task_struct *child, long request,
>  		}
>  
>  		if (ret == 0)
> -			ret = put_user(tmp, (unsigned long *) data);
> +			ret = put_user(tmp, datap);
>  		break;
>  	}
>  
>  	case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
>  		ret = -EIO;
> -		if ((addr & 3) || addr < 0)
> +		if (addr & 3)
>  			break;
>  
> -		ret = 0;
> -		switch (addr >> 2) {
> +		switch (regno) {
>  		case 0 ... PT__END - 1:
> -			ret = put_reg(child, addr >> 2, data);
> -			break;
> -
> -		default:
> -			ret = -EIO;
> +			ret = put_reg(child, regno, data);
>  			break;
>  		}
>  		break;

With this, you remove the default case, and no longer return -EIO in the
cases of PT__END + n, as in the PTRACE_PEEKUSR section above.

This is a change of behaviour as far as I can tell, and not just a cleanup.


Daniel K.
