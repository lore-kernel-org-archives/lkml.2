Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab1FEUBh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 16:01:37 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:53835 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab1FEUBg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 16:01:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=WHdb4NG1wPSoMkS8zSTU7cyyXyjZHl7UIb15bK8AMXRauCnjng1mk45y4FnWppRe8J
         i8Wq5Q6JIe56Y9RRGpwD4C6sWoPIAKZXYddRRKNjEwuGF19kRCoKcyvqv6rYSOV7nPLL
         Pt6MTQCVCGalL1v2fc2F1F0FIb/MZjxpiWq8o=
MIME-Version: 1.0
In-Reply-To: <20110605193001.GB3971@elte.hu>
References: <cover.1307292171.git.luto@mit.edu> <e64e1b3c64858820d12c48fa739efbd1485e79d5.1307292171.git.luto@mit.edu>
 <20110605193001.GB3971@elte.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sun, 5 Jun 2011 16:01:16 -0400
X-Google-Sender-Auth: Vb0DWS-nDCJtYTYAiOfweZsYR24
Message-ID: <BANLkTikQB6=Te6=E7DRmeD5+G4TESuy--w@mail.gmail.com>
Subject: Re: [PATCH v5 8/9] x86-64: Emulate legacy vsyscalls
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 5, 2011 at 3:30 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andy Lutomirski <luto@MIT.EDU> wrote:
>
>> This patch is not perfect: the vread_tsc and vread_hpet functions
>> are still at a fixed address.  Fixing that might involve making
>> alternative patching work in the vDSO.
>
> Can you see any problem with them? Here is how they are looking like
> currently:
>
> ffffffffff600100 <vread_tsc>:
> ffffffffff600100:       55                      push   %rbp
> ffffffffff600101:       48 89 e5                mov    %rsp,%rbp
> ffffffffff600104:       66 66 90                data32 xchg %ax,%ax
> ffffffffff600107:       66 66 90                data32 xchg %ax,%ax
> ffffffffff60010a:       0f 31                   rdtsc
> ffffffffff60010c:       89 c1                   mov    %eax,%ecx
> ffffffffff60010e:       48 89 d0                mov    %rdx,%rax
> ffffffffff600111:       48 8b 14 25 28 0d 60    mov    0xffffffffff600d28,%rdx
> ffffffffff600118:       ff
> ffffffffff600119:       48 c1 e0 20             shl    $0x20,%rax
> ffffffffff60011d:       48 09 c8                or     %rcx,%rax
> ffffffffff600120:       48 39 d0                cmp    %rdx,%rax
> ffffffffff600123:       73 03                   jae    ffffffffff600128 <vread_tsc+0x28>
> ffffffffff600125:       48 89 d0                mov    %rdx,%rax
> ffffffffff600128:       5d                      pop    %rbp
> ffffffffff600129:       c3                      retq
>
> ffffffffff60012a <vread_hpet>:
> ffffffffff60012a:       55                      push   %rbp
> ffffffffff60012b:       48 89 e5                mov    %rsp,%rbp
> ffffffffff60012e:       8b 04 25 f0 f0 5f ff    mov    0xffffffffff5ff0f0,%eax
> ffffffffff600135:       89 c0                   mov    %eax,%eax
> ffffffffff600137:       5d                      pop    %rbp
> ffffffffff600138:       c3                      retq
>
> There's no obvious syscall instruction in them that i can see. No
> 0x0f 0x05 pattern (even misaligned), no 0xcd-anything.

I can't see any problem, but exploit writers are exceedingly clever,
and maybe someone has a use for a piece of the code that isn't a
syscall.  Just as a completely artificial example, here's some buggy
code:

void buggy_function()
{
  attacker_controlled_pointer();
}

long should_be_insecure()
{
  buggy_function();
  return 0;  // We don't want to be exploitable.
}

int main()
{
  if (should_be_insecure())
    chmod("/etc/passwd", 0666);  // Live on the edge!
}

Assume that this code has frame pointers omitted but no other
optimizations.  An exploit could set attacher_controlled_pointer to
0xffffffffff60012e.  Then buggy_function will call the last bit of
vread_hpet, which will set eax to something nonzero, pop the return
address (i.e. the pointer to should_be_insecure) off the stack, then
return to main.  main checks the return value, decides it's nonzero,
and roots the system.

Of course, this is totally artificial and I haven't double-checked my
math, but it's kind of fun to be paranoid.

>
> We could even 'tie down' the actual assembly by moving this all to a
> .S - this way we protect against GCC accidentally generating
> something dangerous in there. I suggested that before.

I have no problem with that suggestion, except that once the current
series makes it into -tip I intend to move vread_tsc and vread_hpet to
the vDSO.  So leaving them alone for now saves work, and they'll be
more maintainable later if they're written in C.

--Andy
