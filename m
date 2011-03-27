Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab1C0RwP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 13:52:15 -0400
Received: from mout.perfora.net ([74.208.4.194]:50544 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753757Ab1C0RwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 13:52:14 -0400
Date: Sun, 27 Mar 2011 13:52:03 -0400
From: Stephen Wilson <wilsons@start.ca>
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Anca Emanuel <anca.emanuel@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, "Luck, Tony" <tony.luck@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: unable to handle kernel paging request
Message-ID: <20110327175203.GA15862@fibrous.localdomain>
References: <AANLkTimYXGQ7BSyuQaqNrW8qp4ETiH8if4-8Gt6LmCyA@mail.gmail.com> <AANLkTikua-zAss=BRA106EqvmawVMUqk5Sc-J=VjvC+8@mail.gmail.com> <AANLkTikyd5GkR_9BUBFeL+Knxd17uozBJoARThVoOrW9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikyd5GkR_9BUBFeL+Knxd17uozBJoARThVoOrW9@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Provags-ID: V02:K0:yxm8syFo4+D5/m1kZJ3dDO7IVBTJzgPzOUxJnUVE4+e
 Rw0vAKVSpJbPbQVXiMQyXylJIGx2LGes/ELrXVYnym7p1/3LGS
 5Z+4vAo2dHCiVdYWjSt8e6F2yCi1pJhRphAQBr/HCZ/Js3vE/S
 E//4+TIjoKErzkh8KZ5gtDKA9Sg36j1cInmVu0+sj+9N4N0MVG
 VgJ46vWMa6pHlpx6Ut2fhzMVsyQFLhb87pWcN/+sdw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 12:00:44AM +0800, Américo Wang wrote:
> On Sun, Mar 27, 2011 at 11:37 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > Al, this smells like your /proc cleanups/fixes...
> >
> > On Sun, Mar 27, 2011 at 2:16 AM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
> >> Hi, I'm using latest kernel git.
> >>
> >>
> >> [15117.080119] BUG: unable to handle kernel paging request at fffffffffffffff3
> >
> > That's "-13" (possibly -EACCES)
> >
> >> [15117.080152] IP: [<ffffffff811b4989>] vma_stop+0x19/0x40
> >
> > .. and the code disassembles to
> >
> >   0:   55                      push   %rbp
> >   1:   48 89 e5                mov    %rsp,%rbp
> >   4:   53                      push   %rbx
> >   5:   48 83 ec 08             sub    $0x8,%rsp
> >   9:   0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
> >   e:   48 85 f6                test   %rsi,%rsi
> >  11:   74 1a                   je     0x2d
> >  13:   48 39 77 10             cmp    %rsi,0x10(%rdi)
> >  17:   74 14                   je     0x2d
> >  19:   8b 1e                   mov    (%rsi),%ebx
> >  1b:   48 8d 7b 60             lea    0x60(%rbx),%rdi
> >  1f:   e8 eb 2f ed ff          callq  up_read
> >
> > where that instruction at 0x19 is the access "mm = vma->vm_mm". So
> > it's vma that is -EPERM.
> >
> > I bet it's due to commit ec6fd8a4355c ("report errors in /proc/*/*map*
> > sanely"), which replaces NULL with various ERR_PTR() cases.
> >
> 
> Exactly... should be fixed by something like:
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 7c708a4..6b82632 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -90,7 +90,7 @@ static void pad_len_spaces(struct seq_file *m, int len)
> 
>  static void vma_stop(struct proc_maps_private *priv, struct
> vm_area_struct *vma)
>  {
> -       if (vma && vma != priv->tail_vma) {
> +       if (vma && !IS_ERR(vma) && vma != priv->tail_vma) {
>                 struct mm_struct *mm = vma->vm_mm;
>                 up_read(&mm->mmap_sem);
>                 mmput(mm);

FWIW, that looks like the right fix to me.

Also CC'ing Tony Luck as he reported what appears to be the same issue
on the 25'th.

-- 
steve

