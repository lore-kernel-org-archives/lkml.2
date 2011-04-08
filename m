Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab1DHUuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 16:50:51 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52927 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757841Ab1DHUuu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 16:50:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=avrchYWmGi4bq0XvGRqrguKZXH3GNet71E7W2RltPCDOXDIHAdGlU5kubAKI3OyJGf
         kbXlQJWKNbvzZ17EcZ8AUZohdq/G2lPeVOxdSa5UVA3G6xwzUycqNdSl9RrIyERcWHiL
         9WizjNNlgudWFwr0+9ffBaAN22bKm0O7FFWCE=
MIME-Version: 1.0
In-Reply-To: <4D9F59AC.6080707@gmail.com>
References: <4D9F59AC.6080707@gmail.com>
Date: Fri, 8 Apr 2011 21:50:49 +0100
Message-ID: <BANLkTi=3FmfeATtdMV1J6ipexk49pvD_BQ@mail.gmail.com>
Subject: Re: trace-cmd errors on kvm events
From: Stefan Hajnoczi <stefanha@gmail.com>
To: David Ahern <dsahern@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        KVM mailing list <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 8, 2011 at 7:53 PM, David Ahern <dsahern@gmail.com> wrote:
> 2.6.38.2 kernel with trace-cmd git pulled this morning:
>
> trace-cmd record -e kvm
>
> trace-cmd report 2>&1 | less
>
> trace-cmd: No such file or directory
>  function ftrace_print_symbols_seq not defined
>  failed to read event print fmt for kvm_nested_vmexit_inject
>  function ftrace_print_symbols_seq not defined
>  failed to read event print fmt for kvm_nested_vmexit
>  function ftrace_print_symbols_seq not defined
>  failed to read event print fmt for kvm_exit
>  bad op token {
>  failed to read event print fmt for kvm_emulate_insn
>
>        qemu-kvm-1864  [002]  2253.714134: kvm_entry:            vcpu 1
>        qemu-kvm-1863  [008]  2253.714136: kvm_exit:             [FAILED
> TO PARSE] exit_reason=44 guest_rip=0xc01185ed isa=1 info1=4272 info2=0
>        qemu-kvm-1864  [002]  2253.714138: kvm_exit:             [FAILED
> TO PARSE] exit_reason=44 guest_rip=0xc01185ed isa=1 info1=4272 info2=0
>        qemu-kvm-1863  [008]  2253.714145: kvm_emulate_insn:     [FAILED
> TO PARSE] rip=3222373869 csbase=0 len=2 insn=<89>^H]<C3><8B>^U<EC><95>K<C0>U
> <89><E5>]<8D>^E flags=5 failed=0
>
> I have not used trace-cmd much, so I am not familiar with the code. Is
> this a known issue? Suggestions on how to debug?

I think there have been issues for a long time.  I've never gotten
perf or trace-cmd to be happy with kvm:* events.  Here is a related
thread from a while back:

https://lkml.org/lkml/2010/5/26/194

When I looked a while back the problem was due to how there is some
preprocessor magic in Linux that ends up exporting C expressions as
strings to userspace and neither perf nor trace-cmd have the parsing
smarts to evaluate the C expressions at runtime.

I ended up using ftrace instead which handles everything inside the
kernel and compiles in those C expressions.

Stefan
