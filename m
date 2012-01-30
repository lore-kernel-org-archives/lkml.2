Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab2A3HX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 02:23:29 -0500
Received: from mga03.intel.com ([143.182.124.21]:42195 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489Ab2A3HX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 02:23:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="101018329"
Subject: Re: Bad SSD performance with recent kernels
From: Shaohua Li <shaohua.li@intel.com>
To: Herbert Poetzl <herbert@13thfloor.at>
Cc: Wu Fengguang <wfg@linux.intel.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
In-Reply-To: <20120130071346.GM29272@MAIL.13thfloor.at>
References: <20120127060034.GG29272@MAIL.13thfloor.at>
	 <20120128125108.GA9661@localhost> <1327757611.7199.6.camel@edumazet-laptop>
	 <20120129055917.GB8513@localhost>
	 <1327831380.14602.6.camel@edumazet-laptop>
	 <20120129111645.GA5839@localhost> <1327842831.2718.2.camel@edumazet-laptop>
	 <20120129161058.GA13156@localhost>
	 <CANejiEW86b7btiOcVFF3qVhqU1t6FRosvgfiydWwU5zgeDFOqw@mail.gmail.com>
	 <20120130071346.GM29272@MAIL.13thfloor.at>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Jan 2012 15:22:38 +0800
Message-ID: <1327908158.21268.3.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-30 at 08:13 +0100, Herbert Poetzl wrote:
> On Mon, Jan 30, 2012 at 11:17:38AM +0800, Shaohua Li wrote:
> > 2012/1/30 Wu Fengguang <wfg@linux.intel.com>:
> >> On Sun, Jan 29, 2012 at 02:13:51PM +0100, Eric Dumazet wrote:
> >>> Le dimanche 29 janvier 2012 à 19:16 +0800, Wu Fengguang a écrit :
> 
> 
> >>>> Note that as long as buffered read(2) is used, it makes almost no
> >>>> difference (well, at least for now) to do "dd bs=128k" or "dd bs=2MB":
> >>>> the 128kb readahead size will be used underneath to submit read IO.
> 
> 
> >>> Hmm...
> 
> >>> # echo 3 >/proc/sys/vm/drop_caches ;dd if=/dev/sda of=/dev/null bs=128k count=32768
> >>> 32768+0 enregistrements lus
> >>> 32768+0 enregistrements écrits
> >>> 4294967296 octets (4,3 GB) copiés, 20,7718 s, 207 MB/s
> 
> 
> >>> # echo 3 >/proc/sys/vm/drop_caches ;dd if=/dev/sda of=/dev/null bs=2M count=2048
> >>> 2048+0 enregistrements lus
> >>> 2048+0 enregistrements écrits
> >>> 4294967296 octets (4,3 GB) copiés, 27,7824 s, 155 MB/s
> 
> >> Interesting. Here are my test results:
> 
> >> root@lkp-nex04 /home/wfg# echo 3 >/proc/sys/vm/drop_caches ;dd if=/dev/sda of=/dev/null bs=128k count=32768
> >> 32768+0 records in
> >> 32768+0 records out
> >> 4294967296 bytes (4.3 GB) copied, 19.0121 s, 226 MB/s
> >> root@lkp-nex04 /home/wfg# echo 3 >/proc/sys/vm/drop_caches ;dd if=/dev/sda of=/dev/null bs=2M count=2048
> >> 2048+0 records in
> >> 2048+0 records out
> >> 4294967296 bytes (4.3 GB) copied, 19.0214 s, 226 MB/s
> 
> >> Maybe the /dev/sda performance bug on your machine is sensitive to timing?
> > I got similar result:
> > 128k: 224M/s
> > 1M: 182M/s
> 
> > 1M block size is slow, I guess it's CPU related.
> 
> > And as for the big regression with newer kernel than 2.6.38,
> > please check if idle=poll helps. CPU idle dramatically impacts
> > disk performance and even latest cpuidle governor doesn't help
> > for some CPUs.
> 
> here are the tests with idle=poll and after switching to 128k
> (instead of 1M) blocksize (same amount of data transferred)
> 
> kernel    ------------ read /dev/sda -------------
>           --- noop ---  - deadline -  ---- cfs ---
>           [MB/s]  %CPU  [MB/s]  %CPU  [MB/s]  %CPU
> --------------------------------------------------
> 3.2.2      45.82   3.7   44.85   3.6   45.04   3.4
> 3.2.2i     45.59   2.3   51.78   2.6   46.03   2.2
> 3.2.2i128 250.24  20.9  252.68  21.3  250.00  21.6
> 
> kernel    -- write ---  ------------------read -----------------
>           --- noop ---  --- noop ---  - deadline -  ---- cfs ---
>           [MB/s]  %CPU  [MB/s]  %CPU  [MB/s]  %CPU  [MB/s]  %CPU
> ----------------------------------------------------------------
> 3.2.2     270.95  42.6  162.36   9.9  162.63   9.9  162.65  10.1
> 3.2.2i    269.10  41.4  170.82   6.6  171.20   6.6  170.91   6.7
> 3.2.2i128 270.38  67.7  162.35  10.2  163.01  10.3  162.34  10.7
What's 3.2.2i and 3.2.2i128? does idle=poll help?

