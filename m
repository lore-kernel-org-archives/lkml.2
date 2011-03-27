Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab1C0QAq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 12:00:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61287 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab1C0QAp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 12:00:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QA4VyUM7T83BDcz/XY2+fmCBw9ogXxerX35HkRtJvcXcxibQ9uomug24UqNKUpiFBS
         a50yDDOuuP4JTIRGxs0H+pOk4StJAA+Y4KCJk6O10p8oFoWLoeZtWJeqbc63AIPZ4/92
         kWb2jjH/D5zmYAbcxoHN29QTywlDtGwQfaJkc=
MIME-Version: 1.0
In-Reply-To: <AANLkTikua-zAss=BRA106EqvmawVMUqk5Sc-J=VjvC+8@mail.gmail.com>
References: <AANLkTimYXGQ7BSyuQaqNrW8qp4ETiH8if4-8Gt6LmCyA@mail.gmail.com>
	<AANLkTikua-zAss=BRA106EqvmawVMUqk5Sc-J=VjvC+8@mail.gmail.com>
Date: Mon, 28 Mar 2011 00:00:44 +0800
Message-ID: <AANLkTikyd5GkR_9BUBFeL+Knxd17uozBJoARThVoOrW9@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel paging request
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Anca Emanuel <anca.emanuel@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 27, 2011 at 11:37 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Al, this smells like your /proc cleanups/fixes...
>
> On Sun, Mar 27, 2011 at 2:16 AM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
>> Hi, I'm using latest kernel git.
>>
>>
>> [15117.080119] BUG: unable to handle kernel paging request at fffffffffffffff3
>
> That's "-13" (possibly -EACCES)
>
>> [15117.080152] IP: [<ffffffff811b4989>] vma_stop+0x19/0x40
>
> .. and the code disassembles to
>
>   0:   55                      push   %rbp
>   1:   48 89 e5                mov    %rsp,%rbp
>   4:   53                      push   %rbx
>   5:   48 83 ec 08             sub    $0x8,%rsp
>   9:   0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
>   e:   48 85 f6                test   %rsi,%rsi
>  11:   74 1a                   je     0x2d
>  13:   48 39 77 10             cmp    %rsi,0x10(%rdi)
>  17:   74 14                   je     0x2d
>  19:   8b 1e                   mov    (%rsi),%ebx
>  1b:   48 8d 7b 60             lea    0x60(%rbx),%rdi
>  1f:   e8 eb 2f ed ff          callq  up_read
>
> where that instruction at 0x19 is the access "mm = vma->vm_mm". So
> it's vma that is -EPERM.
>
> I bet it's due to commit ec6fd8a4355c ("report errors in /proc/*/*map*
> sanely"), which replaces NULL with various ERR_PTR() cases.
>

Exactly... should be fixed by something like:

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 7c708a4..6b82632 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -90,7 +90,7 @@ static void pad_len_spaces(struct seq_file *m, int len)

 static void vma_stop(struct proc_maps_private *priv, struct
vm_area_struct *vma)
 {
-       if (vma && vma != priv->tail_vma) {
+       if (vma && !IS_ERR(vma) && vma != priv->tail_vma) {
                struct mm_struct *mm = vma->vm_mm;
                up_read(&mm->mmap_sem);
                mmput(mm);
