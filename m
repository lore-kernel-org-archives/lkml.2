Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab1HAMpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 08:45:11 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48567 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab1HAMpF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 08:45:05 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1108010229150.1062@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1107290145080.3279@tiger>
	<alpine.DEB.2.00.1107291002570.16178@router.home>
	<alpine.DEB.2.00.1107311136150.12538@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1107311253560.12538@chino.kir.corp.google.com>
	<1312145146.24862.97.camel@jaguar>
	<alpine.DEB.2.00.1107311426001.944@chino.kir.corp.google.com>
	<1312175306.24862.103.camel@jaguar>
	<alpine.DEB.2.00.1108010229150.1062@chino.kir.corp.google.com>
Date: Mon, 1 Aug 2011 15:45:04 +0300
X-Google-Sender-Auth: qLixu4jHoa8bHWkAA_I-bhXosak
Message-ID: <CAOJsxLGyC4=WwGu7kUTwVKF3AxhfWjBg2sZu=W08RtVMHKk8eQ@mail.gmail.com>
Subject: Re: [GIT PULL] Lockless SLUB slowpaths for v3.1-rc1
From: Pekka Enberg <penberg@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, hughd@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Mon, Aug 1, 2011 at 1:02 PM, David Rientjes <rientjes@google.com> wrote:
> Here's the same testing environment with CONFIG_SLUB_STATS for 16 threads
> instead of 160:

[snip]

Looking at the data (in slightly reorganized form):

  alloc
  =====

    16 threads:

      cache           alloc_fastpath          alloc_slowpath
      kmalloc-256     4263275 (91.1%)         417445   (8.9%)
      kmalloc-1024    4636360 (99.1%)         42091    (0.9%)
      kmalloc-4096    2570312 (54.4%)         2155946  (45.6%)

    160 threads:

      cache           alloc_fastpath          alloc_slowpath
      kmalloc-256     10937512 (62.8%)        6490753  (37.2%)
      kmalloc-1024    17121172 (98.3%)        303547   (1.7%)
      kmalloc-4096    5526281  (31.7%)        11910454 (68.3%)

  free
  ====

    16 threads:

      cache           free_fastpath           free_slowpath
      kmalloc-256     210115   (4.5%)         4470604  (95.5%)
      kmalloc-1024    3579699  (76.5%)        1098764  (23.5%)
      kmalloc-4096    67616    (1.4%)         4658678  (98.6%)

    160 threads:
      cache           free_fastpath           free_slowpath
      kmalloc-256     15469    (0.1%)         17412798 (99.9%)
      kmalloc-1024    11604742 (66.6%)        5819973  (33.4%)
      kmalloc-4096    14848    (0.1%)         17421902 (99.9%)

it's pretty sad to see how SLUB alloc fastpath utilization drops so
dramatically. Free fastpath utilization isn't all that great with 160
threads either but it seems to me that most of the performance
regression compared to SLAB still comes from the alloc paths.

I guess the problem here is that __slab_free() happens on a remote CPU
which puts the object to 'struct page' freelist which effectively means
we're unable to recycle free'd objects. As the number of concurrent
threads increase, we simply drain out the fastpath freelists more
quickly. Did I understand the problem correctly?

If that's really happening, I'm still bit puzzled why we're hitting the
slowpath so much. I'd assume that __slab_alloc() would simply reload the
'struct page' freelist once the per-cpu freelist is empty.  Why is that
not happening? I see __slab_alloc() does deactivate_slab() upon
node_match() failure. What kind of ALLOC_NODE_MISMATCH stats are you
seeing?

                        Pekka
