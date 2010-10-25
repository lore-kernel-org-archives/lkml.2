Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759285Ab0JYRyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 13:54:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759121Ab0JYRyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 13:54:01 -0400
Date: Mon, 25 Oct 2010 13:52:50 -0400
From: Jason Baron <jbaron@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        masami.hiramatsu.pt@hitachi.com, rth@redhat.com
Subject: Re: [PATCH][GIT PULL] tracing: Fix compile issue for
	trace_sched_wakeup.c
Message-ID: <20101025175249.GB2884@redhat.com>
References: <20101023200216.GA19324@elte.hu> <1287881618.16971.657.camel@gandalf.stny.rr.com> <20101024112540.GA21267@elte.hu> <20101025085927.GA11025@elte.hu> <20101025093045.GA21997@elte.hu> <20101025114501.GA2000@elte.hu> <20101025121059.GA3063@elte.hu> <1288009103.15336.58.camel@twins> <1288021672.15336.63.camel@twins> <1288028746.3673.11.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288028746.3673.11.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 07:45:46PM +0200, Peter Zijlstra wrote:
> On Mon, 2010-10-25 at 17:47 +0200, Peter Zijlstra wrote:
> 
> > NOP'ed vs JMP'ed
> > 
> 
> >   56:	6a 00                	push   $0x0                          6a 00                	push   $0x0
> >   58:	e8 b7 fe ff ff       	call   0xffffff14                    e8 b7 fe ff ff       	call   0xffffff14
> >   5d:	8b 43 1c             	mov    0x1c(%ebx),%eax               8b 43 1c             	mov    0x1c(%ebx),%eax
> >   60:	89 44 24 04          	mov    %eax,0x4(%esp)                89 44 24 04          	mov    %eax,0x4(%esp)
> >   64:	f0 fe 07             	lock incb (%edi)                     f0 fe 07             	lock incb (%edi)
> >   67:*	0f 1f 44 00 00       	nopl   0x0(%eax,%eax,1)              e9 03 00 00 00       	jmp    0x6f              <--- PATCHED INSN
> >   6c:	58                   	pop    %eax                          58                   	pop    %eax
> >   6d:	eb 1d                	jmp    0x8c                          eb 1d                	jmp    0x8c
> >   6f:	8b 35 70 ad 40 c1    	mov    0xc140ad70,%esi               8b 35 70 ad 40 c1    	mov    0xc140ad70,%esi
> >   75:	85 f6                	test   %esi,%esi                     85 f6                	test   %esi,%esi
> >   77:	74 13                	je     0x8c                          74 13                	je     0x8c
> >   79:	8b 46 04             	mov    0x4(%esi),%eax                8b 46 04             	mov    0x4(%esi),%eax
> >   7c:	89 da                	mov    %ebx,%edx                     89 da                	mov    %ebx,%edx
> >   7e:	8b 4c 24 04          	mov    0x4(%esp),%ecx                8b 4c 24 04          	mov    0x4(%esp),%ecx
> >   82:	ff 16                	call   *(%esi)                       ff 16                	call   *(%esi)
> >   84:	83 c6 08             	add    $0x8,%esi                     83 c6 08             	add    $0x8,%esi
> >   87:	83 3e 00             	cmpl   $0x0,(%esi)                   83 3e 00             	cmpl   $0x0,(%esi)
> >   8a:	eb eb                	jmp    0x77                          eb eb                	jmp    0x77
> >   8c:	89 d8                	mov    %ebx,%eax                     89 d8                	mov    %ebx,%eax
> >   8e:	ff 14 24             	call   *(%esp)                       ff 14 24             	call   *(%esp)
> 
> OK, new theory.. 
> 
> 56 pushl 0
> 67 nopl         jmp 0x6f
>    popl
>    jmp 0x8c
> 
> 6f              mov
>                 test
> 		je 0x8c
> 
> 8c mov
>    call *(%esp)
> 
> 
> So in the jumped path we miss a popl which pop's the 0 pushed before,
> which is the exact address call is failing on..
> 
> Looks like gcc got its branches confused or something..
> 
> Am I reading this right?

Hi Peter,

(adding Richard Henderson to the 'cc list)

Yes, the missing popl in the enabled looked wrong to me as well...I've
been inquiring about this with gcc folks.

thanks,

-Jason 
