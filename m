Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab1FGUA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 16:00:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546Ab1FGUA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 16:00:27 -0400
Message-ID: <4DEE832D.3010901@redhat.com>
Date: Tue, 07 Jun 2011 12:59:41 -0700
From: Josh Stone <jistone@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3.0-rc2-tip 20/22] 20: perf: perf interface for uprobes
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6> <20110607130216.28590.5724.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20110607130216.28590.5724.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2011 06:02 AM, Srikar Dronamraju wrote:
> Enhances perf probe to user space executables and libraries.
> Provides very basic support for uprobes.

Hi Srikar,

This seems to have an issue with multiple active uprobes, whereas the v3
patchset handled this fine.  I haven't tracked down the exact code
difference yet, but here's an example transcript of what I'm seeing:

# perf probe -l
  probe_zsh:main       (on /bin/zsh:0x000000000000e3f0)
  probe_zsh:zalloc     (on /bin/zsh:0x0000000000051120)
  probe_zsh:zfree      (on /bin/zsh:0x0000000000051c70)
# perf stat -e probe_zsh:main zsh -c true

 Performance counter stats for 'zsh -c true':

                 1 probe_zsh:main

       0.029387785 seconds time elapsed

# perf stat -e probe_zsh:zalloc zsh -c true

 Performance counter stats for 'zsh -c true':

               605 probe_zsh:zalloc

       0.043836002 seconds time elapsed

# perf stat -e probe_zsh:zfree zsh -c true

 Performance counter stats for 'zsh -c true':

                36 probe_zsh:zfree

       0.029445890 seconds time elapsed

# perf stat -e probe_zsh:* zsh -c true

 Performance counter stats for 'zsh -c true':

                 0 probe_zsh:zalloc
                 1 probe_zsh:main
                 0 probe_zsh:zfree

       0.030912587 seconds time elapsed

# perf stat -e probe_zsh:z* zsh -c true

 Performance counter stats for 'zsh -c true':

               605 probe_zsh:zalloc
                 0 probe_zsh:zfree

       0.043774671 seconds time elapsed


It seems like among the selected probes, only one with the lowest offset
ever gets hit.  Any ideas?

Thanks,
Josh
