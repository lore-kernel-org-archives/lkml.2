Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759395Ab0I0Nwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 09:52:55 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:59479 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab0I0Nwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 09:52:53 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: caiqian@redhat.com
Cc: Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
References: <986278020.2030861285581319128.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Date: Mon, 27 Sep 2010 06:52:43 -0700
In-Reply-To: <986278020.2030861285581319128.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
	(caiqian@redhat.com's message of "Mon, 27 Sep 2010 05:55:19 -0400
	(EDT)")
Message-ID: <m1zkv3uwd0.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;caiqian@redhat.com
X-Spam-Relay-Country: 
Subject: Re: [PATCH 0/3] Generic support for revoking mappings
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

caiqian@redhat.com writes:

> diff --git a/mm/mmap.c b/mm/mmap.c
> index 6128dc8..00161a4 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -2009,6 +2009,7 @@ static int __split_vma(struct mm_struct * mm, struct vm_area_struct * vma,
>                         removed_exe_file_vma(mm);
>                 fput(new->vm_file);
>         }
> +       unlink_anon_vmas(new);
>   out_free_mpol:
>         mpol_put(pol);
>   out_free_vma:
>
> It became this after manually merged them,

As a conflict resolution doesn't look wrong, but clearly I should rebase
on top of mmtom and see what is going on.

> @@ -2002,20 +2006,15 @@ static int __split_vma(struct mm_struct * mm, struct vm_area_struct * vma,
>                 return 0;
>  
>         /* Clean everything up if vma_adjust failed. */
> -       if (new->vm_ops && new->vm_ops->close)
> -               new->vm_ops->close(new);
> -       if (new->vm_file) {
> -               if (vma->vm_flags & VM_EXECUTABLE)
> -                       removed_exe_file_vma(mm);
> -               fput(new->vm_file);
> -       }
>         unlink_anon_vmas(new);
> +       remove_vma(new);
> + out_err:
> +       return err;
>   out_free_mpol:
>         mpol_put(pol);
>   out_free_vma:
>         kmem_cache_free(vm_area_cachep, new);
> - out_err:
> -       return err;
> +       goto out_err;
>  }

Is it possible that something did not recompile cleanly?  Where I
touched the struct address_space if everything did not rebuild it is
possible for two pieces of incrementally compiled code to think they are
accessing the same fields and are not.

Eric
