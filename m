Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab0J2SOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 14:14:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907Ab0J2SOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 14:14:31 -0400
Message-ID: <4CCB0EE0.4000401@redhat.com>
Date: Fri, 29 Oct 2010 11:13:52 -0700
From: Richard Henderson <rth@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: David Daney <ddaney@caviumnetworks.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com, dsd@laptop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] jump label: disable due to compiler bug
References: <cover.1288212485.git.jbaron@redhat.com>	 <2d1b1d5d2b3930e1acb063cefffbcb2faf049854.1288212486.git.jbaron@redhat.com>	 <ce4ff595-f9d1-4c17-b68e-82739b07ad3e@email.android.com>	 <20101028141757.GA2875@redhat.com> <4CC9C724.3020004@caviumnetworks.com>	 <20101028201112.GA4792@redhat.com> <20101029063450.GE29463@elte.hu>	 <1288354687.18238.433.camel@gandalf.stny.rr.com>	 <20101029122230.GA25663@elte.hu>	 <1288356418.18238.454.camel@gandalf.stny.rr.com>	 <20101029133524.GA23916@Krystal>	 <1288369108.29632.1.camel@gandalf.stny.rr.com>	 <4CCB01D1.2050004@caviumnetworks.com> <1288373582.29632.3.camel@gandalf.stny.rr.com> <4CCB08EB.8070004@caviumnetworks.com>
In-Reply-To: <4CCB08EB.8070004@caviumnetworks.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2010 10:48 AM, David Daney wrote:
> http://gcc.gnu.org/bugzilla/show_bug.cgi?id=46226
> 
> Perhaps it could be integrated with the current checks for the presence of 'asm goto'

If you're looking for a cross-compile-able test, you can strip the
testcase down to 

extern void abort(void);
void g(int x, ...);
void f(int x)
{
  if (x == 0)
    g(0);
  g(1, 2, 3, 4, 5, 6, 7);
  asm goto ("XYZZY" : : : : label);
  abort ();
 label:
  return;
}

and use perl to notice the adjustment to esp before or after XYZZY.
It should be fairly obvious looking at the assembly before and after
the patch.

I don't know what sort of embedded processors supported by linux
actually use ACCUMULATE_OUTGOING_ARGS.  Almost all ports don't, so
I'd be pretty comfortable making this a 32-bit x86 only test, and
let other targets just check that the test compiles.


r~
