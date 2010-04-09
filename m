Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab0DITvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 15:51:23 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47662 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756486Ab0DITuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 15:50:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nzoltOOa4MBDMXBlxHZJ8jK3u3EmZcEasaaP9IhAvvDVFrgORiPEqHr8FMBi6wMAGm
         bMGvKaUyVpr8MHuZbbItuOv+pFgoN2BLMrUSclCSJzSxhitOfJXpSeDp9tzhCgzigPD6
         TjqW+WjI72Gwru/vhR8t7l7ow9xDXxTyInBN4=
MIME-Version: 1.0
In-Reply-To: <1270739687.3066.16.camel@iscandar.digidescorp.com>
References: <x2sb985fb501004071838z51a832dftdfaece15e5a0e154@mail.gmail.com>
	 <1270739687.3066.16.camel@iscandar.digidescorp.com>
Date: Fri, 9 Apr 2010 14:50:49 -0500
Message-ID: <i2yb985fb501004091250i782b9b1ak1698149e10b1b601@mail.gmail.com>
Subject: Re: [PATCH] increase pipe size/buffers/atomicity :D
From: Brian Haslett <knotwurk@gmail.com>
To: steve@digidescorp.com
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=005045013e7fb855b70483d31c96
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--005045013e7fb855b70483d31c96
Content-Type: text/plain; charset=UTF-8

> On Wed, 2010-04-07 at 19:38 -0600, brian wrote:
>> (tested and working with 2.6.32.8 kernel, on a Athlon/686)
>
> It would be good to know what issue this addresses. Gives people a way
> to weigh any side-effects/drawbacks against the benefits, and an
> opportunity to suggest alternate/better approaches.
>

I wouldn't say it addresses anything that I'd really consider broken;
it started as a personal experiment of mine, aimed at some little
performance gain.  I figured, hey, bigger pipes, why not? Looks like
these pipe sizes have practically been around since the epoch.


>>  #define PIPE_BUF_FLAG_LRU      0x01    /* page is on the LRU */
>>  #define PIPE_BUF_FLAG_ATOMIC   0x02    /* was atomically mapped */
>> --- include/asm-generic/page.h.orig     2010-04-06 22:57:08.000000000
>> -0500
>> +++ include/asm-generic/page.h  2010-04-06 22:57:23.000000000 -0500
>> @@ -12,7 +12,7 @@
>>
>>  /* PAGE_SHIFT determines the page size */
>>
>> -#define PAGE_SHIFT     12
>> +#define PAGE_SHIFT     13
>
> This has pretty wide-ranging implications, both within and across
> arches. I don't think it's something that can be changed easily. Also I
> don't believe this #define used in your configuration (Athlon/686)
> unless you're running without a MMU.
>

actually, the reason I went after this, gets into the only reason I
started this whole ordeal to begin with, line#135 in pipe_fs_i.h that
reads "#define PIPE_SIZE    PAGE_SIZE".


>>  #ifdef __ASSEMBLY__
>>  #define PAGE_SIZE      (1 << PAGE_SHIFT)
>>  #else
>> --- include/linux/limits.h.orig 2010-04-06 22:54:15.000000000 -0500
>> +++ include/linux/limits.h      2010-04-06 22:56:28.000000000 -0500
>> @@ -10,7 +10,7 @@
>>  #define MAX_INPUT        255   /* size of the type-ahead buffer */
>>  #define NAME_MAX         255   /* # chars in a file name */
>>  #define PATH_MAX        4096   /* # chars in a path name including nul */
>> -#define PIPE_BUF        4096   /* # bytes in atomic write to a pipe */
>> +#define PIPE_BUF        8192   /* # bytes in atomic write to a pipe */
>

You'd think so (according to some posts I'd read before I tried this),
but I actually tried several variations on a few things, and until I
changed *this one in particular*, my kernel would in fact boot up
fine, but the shell/init/system phase itself would start giving me
errors to the effect of "unable to create pipe" and "too many file
descriptors open" over and over again.

>> --- include/linux/pipe_fs_i.h.orig      2010-04-06 22:56:51.000000000
>> -0500
>> +++ include/linux/pipe_fs_i.h   2010-04-06 22:56:58.000000000 -0500
>> @@ -3,7 +3,7 @@
>>
>>  #define PIPEFS_MAGIC 0x50495045
>>
>> -#define PIPE_BUFFERS (16)
>> +#define PIPE_BUFFERS (32)
>
> This worries me. In several places there are functions with 2 or 3
> pointer arrays of dimension [PIPE_BUFFERS] on the stack. So this adds
> anywhere from 128 to 384 bytes to the stack in these functions depending
> on sizeof(void*) and the number of arrays.
>

As my initial hope/goal was to just increase the size of the pipes, I
figured I may as well increase the buffers as well (although I'll
admit ignorance to not having poked around every little .c/.h file
that calls it).

I guess I wasn't seriously trying to push anyone into jumping through
hoops for this thing, I was just a little excited and figured I'd
share with you all.  I probably spent the better part of a few days
either researching, poking around the kernel headers, or experimenting
with different combinations.   As such, I've attached a .txt file
explaining the controlled (but probably not as thorough as you're used
to) benchmark I ran.   It's not a pretty graph, I know, but gimme a
break, I wrote it in vim and did the math with bc ;)

--005045013e7fb855b70483d31c96
Content-Type: text/plain; charset=US-ASCII; name="benchmark1.txt"
Content-Disposition: attachment; filename="benchmark1.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

JSUlJSUlJSUlJSUlJQpXSVRIT1VUIFBBVENICiUlJSUlJSUlJSUlJSUKCmRkIGlmPS9kZXYvemVy
byBvZj0vcm9vdC9iZW5jaG1hcmsgYnM9NTEyIGNvdW50PTIwMDAwCjIwMDAwKzAgcmVjb3JkcyBp
bgoyMDAwMCswIHJlY29yZHMgb3V0CjEwMjQwMDAwIGJ5dGVzICgxMCBNQikgY29waWVkLCAwLjY3
NDM0NyBzLCAxNS4yIE1CL3MKCmRkIGlmPS9kZXYvemVybyBvZj0vcm9vdC9iZW5jaG1hcmsgYnM9
MTAyNCBjb3VudD0yMDAwMAoyMDAwMCswIHJlY29yZHMgaW4KMjAwMDArMCByZWNvcmRzIG91dAoy
MDQ4MDAwMCBieXRlcyAoMjAgTUIpIGNvcGllZCwgMC44OTM4NiBzLCAyMi45IE1CL3MKCmRkIGlm
PS9kZXYvemVybyBvZj0vcm9vdC9iZW5jaG1hcmsgYnM9MjA0OCBjb3VudD0yMDAwMAoyMDAwMCsw
IHJlY29yZHMgaW4KMjAwMDArMCByZWNvcmRzIG91dAo0MDk2MDAwMCBieXRlcyAoNDEgTUIpIGNv
cGllZCwgMS4zNjIzNyBzLCAzMC4xIE1CL3MKCmRkIGlmPS9kZXYvemVybyBvZj0vcm9vdC9iZW5j
aG1hcmsgYnM9NDA5NiBjb3VudD0yMDAwMAoyMDAwMCswIHJlY29yZHMgaW4KMjAwMDArMCByZWNv
cmRzIG91dAo4MTkyMDAwMCBieXRlcyAoODIgTUIpIGNvcGllZCwgMi44MTAzNyBzLCAyOS4xIE1C
L3MKCj09PT09PT09PT09PT09PTIwMDAwIGJsb2NrcyB3cml0dGVuIGF2ZXJhZ2VkIDI0LjMyNSBN
Qi9zCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09CgpkZCBpZj0vZGV2L3plcm8gb2Y9L3Jvb3QvYmVuY2htYXJrIGJzPTUxMiBjb3VudD00MDAw
MAo0MDAwMCswIHJlY29yZHMgaW4KNDAwMDArMCByZWNvcmRzIG91dAoyMDQ4MDAwMCBieXRlcyAo
MjAgTUIpIGNvcGllZCwgMS4zMTM1NCBzLCAxNS42IE1CL3MKCmRkIGlmPS9kZXYvemVybyBvZj0v
cm9vdC9iZW5jaG1hcmsgYnM9MTAyNCBjb3VudD00MDAwMAo0MDAwMCswIHJlY29yZHMgaW4KNDAw
MDArMCByZWNvcmRzIG91dAo0MDk2MDAwMCBieXRlcyAoNDEgTUIpIGNvcGllZCwgMS44MTczIHMs
IDIyLjUgTUIvcwoKZGQgaWY9L2Rldi96ZXJvIG9mPS9yb290L2JlbmNobWFyayBicz0yMDQ4IGNv
dW50PTQwMDAwCjQwMDAwKzAgcmVjb3JkcyBpbgo0MDAwMCswIHJlY29yZHMgb3V0CjgxOTIwMDAw
IGJ5dGVzICg4MiBNQikgY29waWVkLCAzLjIzNjgzIHMsIDI1LjMgTUIvcwoKZGQgaWY9L2Rldi96
ZXJvIG9mPS9yb290L2JlbmNobWFyayBicz00MDk2IGNvdW50PTQwMDAwCjQwMDAwKzAgcmVjb3Jk
cyBpbgo0MDAwMCswIHJlY29yZHMgb3V0CjE2Mzg0MDAwMCBieXRlcyAoMTY0IE1CKSBjb3BpZWQs
IDYuNzkyOTYgcywgMjQuMSBNQi9zCgo9PT09PT09PT09PT09PT09PT0gNDAwMDAgYmxvY2tzIHdy
aXR0ZW4gYXZlcmFnZWQgMjEuODc1IE1CL3MKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09CgpkZCBpZj0vZGV2L3plcm8gb2Y9L3Jvb3Qv
YmVuY2htYXJrIGJzPTUxMiBjb3VudD04MDAwMAo4MDAwMCswIHJlY29yZHMgaW4KODAwMDArMCBy
ZWNvcmRzIG91dAo0MDk2MDAwMCBieXRlcyAoNDEgTUIpIGNvcGllZCwgMi43MDk2OSBzLCAxNS4x
IE1CL3MKCmRkIGlmPS9kZXYvemVybyBvZj0vcm9vdC9iZW5jaG1hcmsgYnM9MTAyNCBjb3VudD04
MDAwMAo4MDAwMCswIHJlY29yZHMgaW4KODAwMDArMCByZWNvcmRzIG91dAo4MTkyMDAwMCBieXRl
cyAoODIgTUIpIGNvcGllZCwgNC4yNTg3OSBzLCAxOS4yIE1CL3MKCmRkIGlmPS9kZXYvemVybyBv
Zj0vcm9vdC9iZW5jaG1hcmsgYnM9MjA0OCBjb3VudD04MDAwMAo4MDAwMCswIHJlY29yZHMgaW4K
ODAwMDArMCByZWNvcmRzIG91dAoxNjM4NDAwMDAgYnl0ZXMgKDE2NCBNQikgY29waWVkLCA3LjI4
NzUzIHMsIDIyLjUgTUIvcwoKZGQgaWY9L2Rldi96ZXJvIG9mPS9yb290L2JlbmNobWFyayBicz00
MDk2IGNvdW50PTgwMDAwCjgwMDAwKzAgcmVjb3JkcyBpbgo4MDAwMCswIHJlY29yZHMgb3V0CjMy
NzY4MDAwMCBieXRlcyAoMzI4IE1CKSBjb3BpZWQsIDEzLjU0MzYgcywgMjQuMiBNQi9zCgo9PT09
PT09PT09PT09PT09PT09PSA4MDAwMCBibG9ja3Mgd3JpdHRlbiBhdmVyYWdlZCAyMi43NSBNQi9z
Cj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT0KCiUlJSUlJSUlJSUKV0lUSCBQQVRDSCAoISkKJSUlJSUlJSUlJQoKZGQgaWY9L2Rldi96
ZXJvIG9mPS9yb290L2JlbmNobWFyayBicz01MTIgY291bnQ9MjAwMDAKMjAwMDArMCByZWNvcmRz
IGluCjIwMDAwKzAgcmVjb3JkcyBvdXQKMTAyNDAwMDAgYnl0ZXMgKDEwIE1CKSBjb3BpZWQsIDAu
MzU0MzU5IHMsIDI4LjkgTUIvcwoKZGQgaWY9L2Rldi96ZXJvIG9mPS9yb290L2JlbmNobWFyayBi
cz0xMDI0IGNvdW50PTIwMDAwCjIwMDAwKzAgcmVjb3JkcyBpbgoyMDAwMCswIHJlY29yZHMgb3V0
CjIwNDgwMDAwIGJ5dGVzICgyMCBNQikgY29waWVkLCAwLjQ3NDgxOCBzLCA0My4xIE1CL3MKCmRk
IGlmPS9kZXYvemVybyBvZj0vcm9vdC9iZW5jaG1hcmsgYnM9MjA0OCBjb3VudD0yMDAwMAoyMDAw
MCswIHJlY29yZHMgaW4KMjAwMDArMCByZWNvcmRzIG91dAo0MDk2MDAwMCBieXRlcyAoNDEgTUIp
IGNvcGllZCwgMC43OTA0NjYgcywgNTEuOCBNQi9zCgpkZCBpZj0vZGV2L3plcm8gb2Y9L3Jvb3Qv
YmVuY2htYXJrIGJzPTQwOTYgY291bnQ9MjAwMDAKMjAwMDArMCByZWNvcmRzIGluCjIwMDAwKzAg
cmVjb3JkcyBvdXQKODE5MjAwMDAgYnl0ZXMgKDgyIE1CKSBjb3BpZWQsIDEuNTE5NTYgcywgNTMu
OSBNQi9zCgo9PT09PT09PT09PT09PT09PSA0MDAwMCBibG9ja3Mgd3JpdHRlbiBhdmVyYWdlZCA0
NC40MjUgTUIvcyAoKzgyLjYlKQo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQoKZGQgaWY9L2Rldi96ZXJvIG9mPS9yb290
L2JlbmNobWFyayBicz01MTIgY291bnQ9NDAwMDAKNDAwMDArMCByZWNvcmRzIGluCjQwMDAwKzAg
cmVjb3JkcyBvdXQKMjA0ODAwMDAgYnl0ZXMgKDIwIE1CKSBjb3BpZWQsIDAuNzMxMzQ1IHMsIDI4
LjAgTUIvcwoKZGQgaWY9L2Rldi96ZXJvIG9mPS9yb290L2JlbmNobWFyayBicz0xMDI0IGNvdW50
PTQwMDAwCjQwMDAwKzAgcmVjb3JkcyBpbgo0MDAwMCswIHJlY29yZHMgb3V0CjQwOTYwMDAwIGJ5
dGVzICg0MSBNQikgY29waWVkLCAxLjA2MzI5IHMsIDM4LjUgTUIvcwoKZGQgaWY9L2Rldi96ZXJv
IG9mPS9yb290L2JlbmNobWFyayBicz0yMDQ4IGNvdW50PTQwMDAwCjQwMDAwKzAgcmVjb3JkcyBp
bgo0MDAwMCswIHJlY29yZHMgb3V0CjgxOTIwMDAwIGJ5dGVzICg4MiBNQikgY29waWVkLCAxLjg1
MjE4IHMsIDQ0LjIgTUIvcwoKZGQgaWY9L2Rldi96ZXJvIG9mPS9yb290L2JlbmNobWFyayBicz00
MDk2IGNvdW50PTQwMDAwCjQwMDAwKzAgcmVjb3JkcyBpbgo0MDAwMCswIHJlY29yZHMgb3V0CjE2
Mzg0MDAwMCBieXRlcyAoMTY0IE1CKSBjb3BpZWQsIDQuMDgzODYgcywgNDAuMSBNQi9zCgo9PT09
PT09PT09PT09PT09PSA0MDAwMCBibG9ja3Mgd3JpdHRlbiBhdmVyYWdlZCAzNy43IE1CL3MgKCs3
Mi4zJSkKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09CgpkZCBpZj0vZGV2L3plcm8gb2Y9L3Jvb3QvYmVuY2htYXJrIGJzPTUx
MiBjb3VudD04MDAwMAo4MDAwMCswIHJlY29yZHMgaW4KODAwMDArMCByZWNvcmRzIG91dAo0MDk2
MDAwMCBieXRlcyAoNDEgTUIpIGNvcGllZCwgMS41OTU3MyBzLCAyNS43IE1CL3MKCmRkIGlmPS9k
ZXYvemVybyBvZj0vcm9vdC9iZW5jaG1hcmsgYnM9MTAyNCBjb3VudD04MDAwMAo4MDAwMCswIHJl
Y29yZHMgaW4KODAwMDArMCByZWNvcmRzIG91dAo4MTkyMDAwMCBieXRlcyAoODIgTUIpIGNvcGll
ZCwgMi41MTIyMyBzLCAzMi42IE1CL3MKCmRkIGlmPS9kZXYvemVybyBvZj0vcm9vdC9iZW5jaG1h
cmsgYnM9MjA0OCBjb3VudD04MDAwMAo4MDAwMCswIHJlY29yZHMgaW4KODAwMDArMCByZWNvcmRz
IG91dAoxNjM4NDAwMDAgYnl0ZXMgKDE2NCBNQikgY29waWVkLCA0LjU5NjU5IHMsIDM1LjYgTUIv
cwoKZGQgaWY9L2Rldi96ZXJvIG9mPS9yb290L2JlbmNobWFyayBicz00MDk2IGNvdW50PTgwMDAw
CjgwMDAwKzAgcmVjb3JkcyBpbgo4MDAwMCswIHJlY29yZHMgb3V0CjMyNzY4MDAwMCBieXRlcyAo
MzI4IE1CKSBjb3BpZWQsIDEwLjMwMTggcywgMzEuOCBNQi9zCigzMS40MjUtMjIuNzUpLzIyLjc1
Cgo9PT09PT09PT09PT09PT09PT09IDgwMDAwIGJsb2NrcyB3cml0dGVuIGF2ZXJhZ2VkIDMxLjQy
NSBNQi9zICgrMzguMSUpCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PQo=
--005045013e7fb855b70483d31c96--
