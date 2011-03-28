Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab1C1Fqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 01:46:32 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:55245 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab1C1Fq3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 01:46:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sFXa/tWdgNJxTBzfeJyQzzAlpjVvbPpRk5r90IZUKFKaqRR+ujPP8QdFq/5ts5L5Ue
         Yi5IOiayIRExD5DltwQtH3GVA/SF+ZR1DP1CMpUtECfj1MN1eRzNWK/xFgm3OLujnlHn
         5WFvAwh4ap+j0PyqipdBLJPeCwMYXKSnpCuXo=
MIME-Version: 1.0
In-Reply-To: <1301289993-24248-1-git-send-email-amwang@redhat.com>
References: <AANLkTi=mqKF=xeMYbj9LZgPfSLHSkO1JRXsNTW3LyHqu@mail.gmail.com>
	<1301289993-24248-1-git-send-email-amwang@redhat.com>
Date: Mon, 28 Mar 2011 08:46:28 +0300
Message-ID: <AANLkTik32QRUMaKF1aZ02Crh+RFG_4VOCFgPUPnCNLZA@mail.gmail.com>
Subject: Re: [Patch V2] proc: check error pointer returned by m_start()
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, WANG Cong <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric B Munson <emunson@mgebm.net>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 8:26 AM, Amerigo Wang <amwang@redhat.com> wrote:
> From: WANG Cong <xiyou.wangcong@gmail.com>
>
> V2: move the check into m_stop() as suggested by Linus,
> also, most ->show() implementations assume the second parameter 'v'
> is not NULL, this fixes them too.
>
> Anca reported a bug:
>
> [15117.080119] BUG: unable to handle kernel paging request at fffffffffffffff3
> [15117.080152] IP: [<ffffffff811b4989>] vma_stop+0x19/0x40
>
> Linus did the initial analysis, and found this was caused
> by commit ec6fd8a4355c ("report errors in /proc/*/*map*
> sanely"), which replaces NULL with various ERR_PTR() cases.
>
> This is true, that commit changed the return value of m_start(),
> which will return an error pointer on failure, but Al forgot
> to check the error pointer in m_stop() which will be called
> when m_start() fails. This patches fixes it.
>
> Reported-by: Anca Emanuel <anca.emanuel@gmail.com>
> Tested-by: Anca Emanuel <anca.emanuel@gmail.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
>
> ---
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 7c708a4..8e59169 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -124,8 +124,10 @@ static void *m_start(struct seq_file *m, loff_t *pos)
>                return ERR_PTR(-ESRCH);
>
>        mm = mm_for_maps(priv->task);
> -       if (!mm || IS_ERR(mm))
> +       if (IS_ERR_OR_NULL(mm)) {
> +               put_task_struct(priv->task);
>                return mm;
> +       }
>        down_read(&mm->mmap_sem);
>
>        tail_vma = get_gate_vma(priv->task->mm);
> @@ -182,6 +184,8 @@ static void m_stop(struct seq_file *m, void *v)
>        struct proc_maps_private *priv = m->private;
>        struct vm_area_struct *vma = v;
>
> +       if (IS_ERR_OR_NULL(v))
> +               return;

Note: this is not functional equivalent with the previous patch.

>        vma_stop(priv, vma);
>        if (priv->task)
>                put_task_struct(priv->task);
> diff --git a/fs/seq_file.c b/fs/seq_file.c
> index 05d6b0e..e17d5e6 100644
> --- a/fs/seq_file.c
> +++ b/fs/seq_file.c
> @@ -83,7 +83,7 @@ static int traverse(struct seq_file *m, loff_t offset)
>        p = m->op->start(m, &index);
>        while (p) {
>                error = PTR_ERR(p);
> -               if (IS_ERR(p))
> +               if (IS_ERR_OR_NULL(p))
>                        break;
>                error = m->op->show(m, p);
>                if (error < 0)
> --

I din't test the above patch.

Linus already have the fix in his tree.
