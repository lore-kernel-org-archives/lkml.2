Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab2DNJpM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 05:45:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60870 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab2DNJpK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 05:45:10 -0400
Message-ID: <1334396693.2528.45.camel@twins>
Subject: Re: kvm: RCU warning in async pf
From: Peter Zijlstra <peterz@infradead.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        kvm <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Date: Sat, 14 Apr 2012 11:44:53 +0200
In-Reply-To: <20120404123033.GD11918@redhat.com>
References: <1333414472.11455.7.camel@lappy>
	 <20120403105226.GF14939@redhat.com> <20120404123033.GD11918@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-04 at 15:30 +0300, Gleb Natapov wrote:
>  
> @@ -253,7 +254,10 @@ do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
>  		kvm_async_pf_task_wait((u32)read_cr2());
>  		break;
>  	case KVM_PV_REASON_PAGE_READY:
> +		rcu_irq_enter();
> +		exit_idle();
>  		kvm_async_pf_task_wake((u32)read_cr2());
> +		rcu_irq_exit();
>  		break;
>  	}
>  }

Wouldn't irq_enter() / irq_exit() be more appropriate? You're basically
taking an interrupt/exception from idle, irq_enter() will fix up
everything that needs fixing up, including time sources (which the
scheduler expects to be up-to-date).


