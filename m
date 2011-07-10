Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab1GJQ0L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 12:26:11 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59341 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab1GJQ0I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 12:26:08 -0400
MIME-Version: 1.0
In-Reply-To: <4E199633.9050200@hitachi.com>
References: <20110710100005.2550.83138.stgit@fedora15>
	<20110710100033.2550.78762.stgit@fedora15>
	<CAOJsxLHxWESTZa60hopBXUnTGn7-hJasuw_t7QAnv417TzMFBw@mail.gmail.com>
	<4E199633.9050200@hitachi.com>
Date: Sun, 10 Jul 2011 19:26:07 +0300
X-Google-Sender-Auth: bU-ambjU8pwRJ5MbaIqmVUJPrl4
Message-ID: <CAOJsxLEhZ-+e=H+9O_wn0F_jTp-BJKLURz7=q1HMb_Nhg0gaWw@mail.gmail.com>
Subject: Re: [PATCH -tip 4/5] [BUGFIX] perf probe: Fix the order of searching
 scopes for variables
From: Pekka Enberg <penberg@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 3:08 PM, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
> Hi Pekka,
>
> (2011/07/10 20:05), Pekka Enberg wrote:
>> On Sun, Jul 10, 2011 at 1:00 PM, Masami Hiramatsu
>> <masami.hiramatsu.pt@hitachi.com> wrote:
>>> Fix variable searching routine to search from inner scope
>>> to outer scope.
>>
>> Admittedly, I don't really know this code at all. However, the
>> changelog is somewhat vague. Why do we need this change? What problem
>> does it fix? Why does the order in which we iterate 'scopes' matter?
>
> Hmm, I see.
>
> Debuginfo expresses functions and nested inlined functions as
> DIE(Dwarf Information Entry) tree, and "scope" means each
> level of the DIE.
>
> Outer
> ^
> |
>  CU DIE [A](compile unit: it's an object file)
>   +-global variable DIEs
>   +-inline function declaration DIEs
>   +-function [B] DIE
>      +-local variable DIEs
>      +-inline function instance [C] DIE
>         +-inline local variable DIEs
>         +-(nested)inline function instance [D] DIE
>            +...
> |
> v
> Inner
>
> Imagine that if we are at [C],
>
> nscopes = dwarf_getscopes_die([C], &scopes)
>
> this returns scopes[] DIEs containing [C] DIE, and nscopes = 3
> On that array, scopes[0] is [C], scopes[1] is [B], and scopes[2]
> is [A].
>
> And, the below loop
>
>  while (nscopes-- > 1)
>        die_find_variable_at(&scopes[nscopes], ...
>
> starts to find variables from the outermost scope [A] and
> find a global variable first.　This changes searching order
> from inner scope ([B]) to outer ([A]) to search global vars
> last.

Thanks for the explanation! What kind of problems does this cause for
'perf probe' users?
