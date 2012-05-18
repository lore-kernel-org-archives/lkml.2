Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965254Ab2ERQud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:50:33 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:36058 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233Ab2ERQua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:50:30 -0400
MIME-Version: 1.0
In-Reply-To: <4FB67CD6.8040103@zytor.com>
References: <4FB67146.9080804@zytor.com>
	<CAMe9rOqp5AUNL7Oeb2fz=nFq6Z-=hdFg_T2kc+jwkYtzOKJv9g@mail.gmail.com>
	<CAMe9rOp-UoQFBvvorZA8-jBXk5JobkVa+trUH7ihHLxNyqMuWw@mail.gmail.com>
	<4FB67697.50904@zytor.com>
	<CAMe9rOqAJGemCiAebtYczqvV62J_cyZcZDDtkFZyLHPKZg1xqQ@mail.gmail.com>
	<4FB67CD6.8040103@zytor.com>
Date: Fri, 18 May 2012 09:50:29 -0700
Message-ID: <CAMe9rOpUoj_1TM0NOqVX31aHEez3_i9v6f7_zkGeM8SZ+XDxyQ@mail.gmail.com>
Subject: Re: Urgent: x86-32 and GNU ld 2.22.52.0.1
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 9:46 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/18/2012 09:35 AM, H.J. Lu wrote:
>>
>> In that case, both 2.22.52.0.1 and 2.22.52.0.2 are bad.
>>
>
> I suspect that really means we should have a patch which verifies by
> construction, and not rely on version numbers.
>

A small testcase:

[hjl@gnu-6 pr14052]$ cat pr14052.s
	.text
	.global start	/* Used by SH targets.  */
start:
	.global _start
_start:
	.global __start
__start:
	.global main	/* Used by HPPA targets.  */
main:
	.dc.a 0
[hjl@gnu-6 pr14052]$ cat pr14052.t
SECTIONS {
	.text : {
		*(.text)
	}
	. = ALIGN (0x1000);
	.data : {
		_data_start = .;
		*(.data)
	}
	/DISCARD/ : { *(.*) }
}
[hjl@gnu-6 pr14052]$ make
as   -o pr14052.o pr14052.s
./ld  -o pr14052 -T pr14052.t pr14052.o
readelf -s pr14052

Symbol table '.symtab' contains 7 entries:
   Num:    Value          Size Type    Bind   Vis      Ndx Name
     0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND
     1: 0000000000000000     0 SECTION LOCAL  DEFAULT    1
     2: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT    1 __start
     3: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT    1 _start
     4: 0000000000001000     0 NOTYPE  GLOBAL DEFAULT    1 _data_start
     5: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT    1 main
     6: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT    1 start
[hjl@gnu-6 pr14052]$

There should be no symbols in ABS section.

-- 
H.J.
