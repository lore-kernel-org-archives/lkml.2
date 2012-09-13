Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432Ab2IMSCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 14:02:13 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39612 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab2IMSCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 14:02:11 -0400
Date: Thu, 13 Sep 2012 14:01:48 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alex Kelly <alex.page.kelly@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Cong Wang <amwang@redhat.com>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Jiri Moskovcak <jmoskovc@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] coredump: add support for %d=__get_dumpable() in
 core name
Message-ID: <20120913180148.GB2761@neilslaptop.think-freely.org>
References: <20120913172817.GA11337@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913172817.GA11337@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 07:28:17PM +0200, Oleg Nesterov wrote:
> https://bugzilla.redhat.com/show_bug.cgi?id=787135
> 
> Some coredump handlers want to create a core file in a way compatible
> with standard behavior. Standard behavior with fs.suid_dumpable = 2
> is to create core file with uid=gid=0. However, there was no way for
> coredump handler to know that the process being dumped was suid'ed.
> 
> This patch adds the new %d specifier for format_corename() which
> simply reports __get_dumpable(mm->flags), this is compatible with
> /proc/sys/fs/suid_dumpable we already have.
> 
> By-discussion-with: Denys Vlasenko <vda.linux@googlemail.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  fs/coredump.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/coredump.c b/fs/coredump.c
> index 1935b4d..aad8715 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -149,7 +149,7 @@ put_exe_file:
>   * name into corename, which must have space for at least
>   * CORENAME_MAX_SIZE bytes plus one byte for the zero terminator.
>   */
> -static int format_corename(struct core_name *cn, long signr)
> +static int format_corename(struct core_name *cn, struct coredump_params *cprm)
>  {
>  	const struct cred *cred = current_cred();
>  	const char *pat_ptr = core_pattern;
> @@ -194,9 +194,13 @@ static int format_corename(struct core_name *cn, long signr)
>  			case 'g':
>  				err = cn_printf(cn, "%d", cred->gid);
>  				break;
> +			case 'd':
> +				err = cn_printf(cn, "%d",
> +					__get_dumpable(cprm->mm_flags));
> +				break;
>  			/* signal that caused the coredump */
>  			case 's':
> -				err = cn_printf(cn, "%ld", signr);
> +				err = cn_printf(cn, "%ld", cprm->signr);
>  				break;
>  			/* UNIX time of coredump */
>  			case 't': {
> @@ -524,7 +528,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
>  	 */
>  	clear_thread_flag(TIF_SIGPENDING);
>  
> -	ispipe = format_corename(&cn, signr);
> +	ispipe = format_corename(&cn, &cprm);
>  
>   	if (ispipe) {
>  		int dump_count;
> -- 
> 1.5.5.1
> 
> 
> 
Looks reasonable
Acked-by: Neil Horman <nhorman@tuxdriver.com>

