Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759162Ab0JYRqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 13:46:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:54195 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab0JYRqS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 13:46:18 -0400
Subject: Re: [PATCH][GIT PULL] tracing: Fix compile issue for
 trace_sched_wakeup.c
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        masami.hiramatsu.pt@hitachi.com
In-Reply-To: <1288021672.15336.63.camel@twins>
References: <20101021110925.GA27219@elte.hu>
	 <20101022175845.GF6498@redhat.com> <20101022182433.GA24637@elte.hu>
	 <20101022183900.GG6498@redhat.com> <20101023200216.GA19324@elte.hu>
	 <1287881618.16971.657.camel@gandalf.stny.rr.com>
	 <20101024112540.GA21267@elte.hu> <20101025085927.GA11025@elte.hu>
	 <20101025093045.GA21997@elte.hu> <20101025114501.GA2000@elte.hu>
	 <20101025121059.GA3063@elte.hu>  <1288009103.15336.58.camel@twins>
	 <1288021672.15336.63.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 25 Oct 2010 19:45:46 +0200
Message-ID: <1288028746.3673.11.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 17:47 +0200, Peter Zijlstra wrote:

> NOP'ed vs JMP'ed
> 

>   56:	6a 00                	push   $0x0                          6a 00                	push   $0x0
>   58:	e8 b7 fe ff ff       	call   0xffffff14                    e8 b7 fe ff ff       	call   0xffffff14
>   5d:	8b 43 1c             	mov    0x1c(%ebx),%eax               8b 43 1c             	mov    0x1c(%ebx),%eax
>   60:	89 44 24 04          	mov    %eax,0x4(%esp)                89 44 24 04          	mov    %eax,0x4(%esp)
>   64:	f0 fe 07             	lock incb (%edi)                     f0 fe 07             	lock incb (%edi)
>   67:*	0f 1f 44 00 00       	nopl   0x0(%eax,%eax,1)              e9 03 00 00 00       	jmp    0x6f              <--- PATCHED INSN
>   6c:	58                   	pop    %eax                          58                   	pop    %eax
>   6d:	eb 1d                	jmp    0x8c                          eb 1d                	jmp    0x8c
>   6f:	8b 35 70 ad 40 c1    	mov    0xc140ad70,%esi               8b 35 70 ad 40 c1    	mov    0xc140ad70,%esi
>   75:	85 f6                	test   %esi,%esi                     85 f6                	test   %esi,%esi
>   77:	74 13                	je     0x8c                          74 13                	je     0x8c
>   79:	8b 46 04             	mov    0x4(%esi),%eax                8b 46 04             	mov    0x4(%esi),%eax
>   7c:	89 da                	mov    %ebx,%edx                     89 da                	mov    %ebx,%edx
>   7e:	8b 4c 24 04          	mov    0x4(%esp),%ecx                8b 4c 24 04          	mov    0x4(%esp),%ecx
>   82:	ff 16                	call   *(%esi)                       ff 16                	call   *(%esi)
>   84:	83 c6 08             	add    $0x8,%esi                     83 c6 08             	add    $0x8,%esi
>   87:	83 3e 00             	cmpl   $0x0,(%esi)                   83 3e 00             	cmpl   $0x0,(%esi)
>   8a:	eb eb                	jmp    0x77                          eb eb                	jmp    0x77
>   8c:	89 d8                	mov    %ebx,%eax                     89 d8                	mov    %ebx,%eax
>   8e:	ff 14 24             	call   *(%esp)                       ff 14 24             	call   *(%esp)

OK, new theory.. 

56 pushl 0
67 nopl         jmp 0x6f
   popl
   jmp 0x8c

6f              mov
                test
		je 0x8c

8c mov
   call *(%esp)


So in the jumped path we miss a popl which pop's the 0 pushed before,
which is the exact address call is failing on..

Looks like gcc got its branches confused or something..

Am I reading this right?
