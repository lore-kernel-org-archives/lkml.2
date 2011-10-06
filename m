Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965259Ab1JFRxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:53:36 -0400
Received: from claw.goop.org ([74.207.240.146]:33771 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965181Ab1JFRxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:53:35 -0400
Message-ID: <4E8DEB19.1050509@goop.org>
Date: Thu, 06 Oct 2011 10:53:29 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        peterz@infradead.org
Subject: Re: [PATCH RFC V2 3/5] jump_label: if a key has already been initialized,
 don't nop it out
References: <cover.1317506051.git.jeremy.fitzhardinge@citrix.com> <477dead9647029012f93c651f2892ed0e86b89e7.1317506051.git.jeremy.fitzhardinge@citrix.com> <20111003150205.GB2462@redhat.com> <4E89E28C.7010700@goop.org> <20111004141011.GA2520@redhat.com> <4E8B3489.60902@zytor.com> <4E8CF348.4080405@goop.org> <4E8CF385.2080804@zytor.com>
In-Reply-To: <4E8CF385.2080804@zytor.com>
X-Enigmail-Version: 1.3.2
Content-Type: multipart/mixed;
 boundary="------------060407060807030203080909"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060407060807030203080909
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/05/2011 05:17 PM, H. Peter Anvin wrote:
> On 10/05/2011 05:16 PM, Jeremy Fitzhardinge wrote:
>> On 10/04/2011 09:30 AM, H. Peter Anvin wrote:
>>> On 10/04/2011 07:10 AM, Jason Baron wrote:
>>>> 1) The jmp +0, is a 'safe' no-op that I know is going to initially
>>>> boot for all x86. I'm not sure if there is a 5-byte nop that works on
>>>> all x86 variants - but by using jmp +0, we make it much easier to debug
>>>> cases where we may be using broken no-ops.
>>>>
>>> There are *plenty*.  jmp+0 is about as pessimal as you can get.
>> As an aside, do you know if a 2-byte unconditional jmp is any more
>> efficient than 5-byte, aside from just being a smaller instruction and
>> taking less icache?
>>
> I don't know for sure, no.  I probably depends on the CPU.

Looks like jmp2 is about 5% faster than jmp5 on Sandybridge with this
benchmark.

But insignificant difference on Nehalem.

    J

--------------060407060807030203080909
Content-Type: text/x-csrc;
 name="jmp2.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="jmp2.c"

#include <stdio.h>

struct {
	unsigned char flag;
	unsigned char val;
} l;

#define JMP2	asm volatile ("jmp 1f; .byte 0x0f,0x1f,0x00; 1: ");
#define JMPJMP2	JMP2 JMP2
#define JMPJMPJMP2	JMPJMP2 JMPJMP2
#define JMPJMPJMP2	JMPJMP2 JMPJMP2
#define JMPJMPJMPJMP2	JMPJMPJMP2 JMPJMPJMP2
#define JMPJMPJMPJMPJMP2	JMPJMPJMPJMP2 JMPJMPJMPJMP2
#define JMPJMPJMPJMPJMPJMP2	JMPJMPJMPJMPJMP2 JMPJMPJMPJMPJMP2

int main(int argc, char **argv)
{
	int i;

	for (i = 0; i < 100000000; i++) {
		JMPJMPJMPJMPJMPJMP2;
		asm volatile("" : : : "memory");
	}

	return 0;
}

--------------060407060807030203080909
Content-Type: text/x-csrc;
 name="jmp5.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="jmp5.c"

#include <stdio.h>

struct {
	unsigned char flag;
	unsigned char val;
} l;

#define JMP5	asm volatile (".byte 0xe9; .long 0");
#define JMPJMP5	JMP5 JMP5
#define JMPJMPJMP5	JMPJMP5 JMPJMP5
#define JMPJMPJMP5	JMPJMP5 JMPJMP5
#define JMPJMPJMPJMP5	JMPJMPJMP5 JMPJMPJMP5
#define JMPJMPJMPJMPJMP5	JMPJMPJMPJMP5 JMPJMPJMPJMP5
#define JMPJMPJMPJMPJMPJMP5	JMPJMPJMPJMPJMP5 JMPJMPJMPJMPJMP5

int main(int argc, char **argv)
{
	int i;

	for (i = 0; i < 100000000; i++) {
		JMPJMPJMPJMPJMPJMP5;
		asm volatile("" : : : "memory");
	}

	return 0;
}

--------------060407060807030203080909--
