Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab1JTOQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 10:16:06 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38536 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab1JTOQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 10:16:05 -0400
Message-ID: <4EA02D1F.30800@gmail.com>
Date: Thu, 20 Oct 2011 08:15:59 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com
Subject: Re: [PATCH] perf top: fix crash on annotate request
References: <1319048598-15030-1-git-send-email-dsahern@gmail.com> <20111019183848.GE2229@ghostprotocols.net> <4E9F1AA0.4010706@gmail.com> <20111019192011.GG2229@ghostprotocols.net> <4E9F4B50.1060207@gmail.com> <20111020130041.GB1772@ghostprotocols.net>
In-Reply-To: <20111020130041.GB1772@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/20/2011 07:00 AM, Arnaldo Carvalho de Melo wrote:
> Em Wed, Oct 19, 2011 at 04:12:32PM -0600, David Ahern escreveu:
> 
> But this one seems like papering over some real problem, i.e. why would
> we ask to bump an address that is _outside_ this symbol range? I.e.:
> 
> In record_precise_ip() this part must be wrong:
> 
>         ip = he->ms.map->map_ip(he->ms.map, ip);
>         symbol__inc_addr_samples(sym, he->ms.map, counter, ip)
> 
> I.e. the map_ip for this method is messing up things, what symbol is
> this? I.e. please provide:
> 
> p *sym
> p *map
> 
> - Arnaldo

recreated. new backtrace:
(gdb) bt
#0  0x0000000000429de3 in symbol__inc_addr_samples (sym=0xd744d0,
map=0x11d0650, evidx=0,
    addr=140081) at util/annotate.c:73
#1  0x000000000041b073 in record_precise_ip (he=0x126cd10, counter=0,
ip=140081)
    at builtin-top.c:221
#2  0x000000000041c821 in perf_event__process_sample (event=0x7ffff7e67510,
    sample=0x7fffffffa0e0, session=0x8774a0) at builtin-top.c:801
#3  0x000000000041c8d4 in perf_session__mmap_read_idx (self=0x8774a0,
idx=2) at builtin-top.c:821
#4  0x000000000041c95b in perf_session__mmap_read (self=0x8774a0) at
builtin-top.c:832
#5  0x000000000041ce94 in __cmd_top () at builtin-top.c:981
#6  0x000000000041d585 in cmd_top (argc=0, argv=0x7fffffffa4c0,
prefix=0x0) at builtin-top.c:1252
#7  0x00000000004077b9 in run_builtin (p=0x75fb68, argc=2,
argv=0x7fffffffa4c0) at perf.c:286
#8  0x00000000004079bb in handle_internal_command (argc=2,
argv=0x7fffffffa4c0) at perf.c:358
#9  0x0000000000407b07 in run_argv (argcp=0x7fffffffa3ac,
argv=0x7fffffffa3a0) at perf.c:402
#10 0x0000000000407dee in main (argc=2, argv=0x7fffffffa4c0) at perf.c:512

(gdb) fr 1
(gdb) p *sym
$2 = {
  rb_node = {
    rb_parent_color = 14360401,
    rb_right = 0x0,
    rb_left = 0x0
  },
  start = 484096,
  end = 484282,
  namelen = 13,
  binding = 0 '\000',
  ignore = false,
  name = 0xd744d0 "Q\037", <incomplete sequence \333>
}

(gdb) p *he
$5 = {
  rb_node_in = {
    rb_parent_color = 19381681,
    rb_right = 0x13396c0,
    rb_left = 0x1287cb0
  },
  rb_node = {
    rb_parent_color = 0,
    rb_right = 0x0,
    rb_left = 0x0
  },
  period = 7072393,
  period_sys = 0,
  period_us = 7072393,
  period_guest_sys = 0,
  period_guest_us = 0,
  ms = {
    map = 0x11d0650,
    sym = 0xd744d0,
    unfolded = false,
    has_children = false
  },
  thread = 0x1071b00,
  ip = 484204,
  cpu = -1,
  nr_events = 7,
  row_offset = 0,
  nr_rows = 0,
  init_have_children = false,
  level = 46 '.',
  used = false,
  filtered = 0 '\000',
  parent = 0x0,
  {
    position = 0,
    pair = 0x0,
    sorted_chain = {
      rb_node = 0x0
    }
  },
  callchain = 0x126cd10
}

(gdb) p {struct map} 0x11d0650
$7 = {
  {
    rb_node = {
      rb_parent_color = 1,
      rb_right = 0x11d0320,
      rb_left = 0x11cfc00
    },
    node = {
      next = 0x1,
      prev = 0x11d0320
    }
  },
  start = 4150226944,
  end = 4151816191,
  type = 0 '\000',
  referenced = true,
  priv = 0,
  pgoff = 0,
  map_ip = 0x4506ed <map__map_ip>,
  unmap_ip = 0x45073d <map__unmap_ip>,
  dso = 0x88f820,
  groups = 0x1071b18
}

