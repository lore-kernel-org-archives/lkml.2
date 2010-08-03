Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab0HCNyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 09:54:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755865Ab0HCNyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 09:54:36 -0400
Date: Tue, 3 Aug 2010 10:54:20 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Dave Martin <dave.martin@linaro.org>
Cc: linux-kernel@vger.kernel.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        kernel-team@lists.ubuntu.com, Will Deacon <Will.Deacon@arm.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>
Subject: Re: [PATCH 0/2] perf: symbol offset breakage with separated debug
Message-ID: <20100803135420.GV29507@ghostprotocols.net>
References: <1280836116-6654-1-git-send-email-dave.martin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280836116-6654-1-git-send-email-dave.martin@linaro.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Aug 03, 2010 at 12:48:34PM +0100, Dave Martin escreveu:
> Hi all,
> 
> I've hit some problems in trying to get perf record/report to
> work correctly on systems with separated debug images (Ubuntu,
> in particular).  I worked on some patches to ensure that
> separate debug images do actually get loaded, when present --
> these commits have now been merged in linux-2.6-tip/master.
> (See below for a list of the commits.)
> 
> Now that these are in place, I'm observing a new problem which
> can mess up symbol locations -- though I think there might be a
> practical workaround, I can't see a trivial solution, so I'm
> keen to hear if anyone has any ideas.
> 
> 
> The problem:
> 
> perf makes some incorrect assumptions, which mean that the
> symbol locations seen by perf report and friends can be
> incorrect.
> 
> My analysis:
> 
> 	a) perf represents symbols as offsets from the start of
> 		the mmap'd code region which contains each
> 		symbol.

The symbol library in perf uses separate map_ip and unmap_ip to cope
with those, covering things like prelinked binaries, the kernel with its
absolute addresses, kexec cases where we capture a reference relocation
symbol so that we can adjust later when using the unrelocated vmlinux,
etc.
 
> 	b) For shared libs (ET_DYN objects), the desired offset
> 		is (usually) equal to the VMA of each given

VMA here stands for Virtual Memory Address, not Virtual Memory Area
where a map is loaded, right? I guess so, but trying to get to common
ground.

> 		symbol in the image.  Perf assumes that these
> 		offsets are always equal, and this normally
> 		works.
> 
> 		Atypical link configurations could cause this

Which ones? We need to detect those and act accordingly, doing
adjustments at load time or by using a separate map_ip/unmap_ip pair of
functions in struct map.

I'll continue reading your patches, the first one probably fixes a bug,
but wonder if you looked at the struct map->{map_ip,unmap_ip} routines
in tools/perf/util/map.h.

- Arnaldo
