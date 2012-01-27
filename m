Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab2A0K2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 05:28:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36325 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab2A0K16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 05:27:58 -0500
Date: Fri, 27 Jan 2012 11:27:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: =?iso-8859-1?B?TOluYe9j?= Huard <lenaic@lhuard.fr.eu.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: Shift by one instruction in the perf annotate output
Message-ID: <20120127102741.GA31782@elte.hu>
References: <201201270001.27765.lenaic@lhuard.fr.eu.org>
 <1327652120.2446.123.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1327652120.2446.123.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > I am running Linux and perf 3.2 but I remember that previous 
> > versions suffered from the same issue.
> > 
> > I don’t know if it could be specific to my cpu:
> > processor       : 0
> > vendor_id       : GenuineIntel
> > cpu family      : 6
> > model           : 15
> > model name      : Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz 
> 
> And sadly its the best you'll get on your machine, most Intel 
> chips after that (including the core2 shrink, but excluding 
> the latest core i7 SNB) can do better using a feature called 
> PEBS.

Which can be activated on those CPUs using the '-e cycles:pp' 
option (the first 'p' stands for 'precise', the second 'p' for 
'very precise' ;-).

In that case some rather non-obvious perf magic is activated (we 
use PEBS for precise samples and use the LBR hardware to rewind 
the IP), due to which annotation output looks like this:

         :        ffffffff810a6f51 <do_raw_spin_lock>:                                            ▒
    1.77 :        ffffffff810a6f51:       mov    $0x10000,%eax                                    ▒
   44.95 :        ffffffff810a6f56:       lock xadd %eax,(%rdi)                                   ▒
    1.25 :        ffffffff810a6f5a:       mov    %eax,%edx                                        ▒
    0.29 :        ffffffff810a6f5c:       shr    $0x10,%edx                                       ▒
    1.21 :        ffffffff810a6f5f:       cmp    %dx,%ax                                          ▒
    0.01 :        ffffffff810a6f62:       je     ffffffff810a6f6b <do_raw_spin_lock+0x1a>         ▒
   29.81 :        ffffffff810a6f64:       pause                                                   ▒
   16.45 :        ffffffff810a6f66:       mov    (%rdi),%ax                                       ▒
    4.27 :        ffffffff810a6f69:       jmp    ffffffff810a6f5f <do_raw_spin_lock+0xe>          ▒
    0.00 :        ffffffff810a6f6b:       retq                                                    ▒

the entries are both precise and show up in the right place.

On Core2 CPUs there's PEBS so 'p' will work, but there's no LBR 
so the IP-rewinding does not work.

Thanks,

	Ingo
