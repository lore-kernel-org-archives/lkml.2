Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678Ab2I2Sws (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 14:52:48 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:52738 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757328Ab2I2Swr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 14:52:47 -0400
Date: Sat, 29 Sep 2012 20:52:43 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, tools: Add library dependencies for static perf
 link
Message-ID: <20120929185243.GB250@x4>
References: <1348942428-29688-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348942428-29688-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.09.29 at 11:13 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> When linking perf statically some of the library dependencies are always
> rejected, so libdwarf and libbfd do not work.  The problem is that these
> libraries (at least on my system) require other libraries. But unlike
> a shared link the static link doesn't find those by itself, and they
> have to be explicitely specified.
> 
> In my case I needed -ldl -lz for libbfd and -lslang for -lnewt
> 
> Add those to the probe statements.

Just two little nitpicks.

> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/Makefile |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 35655c3..a79c702 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -491,7 +491,7 @@ endif # NO_DWARF
>  ifdef NO_NEWT
>  	BASIC_CFLAGS += -DNO_NEWT_SUPPORT
>  else
> -	FLAGS_NEWT=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -lnewt
> +	FLAGS_NEWT=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -lnewt -lslang
>  	ifneq ($(call try-cc,$(SOURCE_NEWT),$(FLAGS_NEWT)),y)
>  		msg := $(warning newt not found, disables TUI support. Please install newt-devel or libnewt-dev);
>  		BASIC_CFLAGS += -DNO_NEWT_SUPPORT
> @@ -644,20 +644,20 @@ else
>  		EXTLIBS += -liberty
>  		BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
>          else
> -		FLAGS_BFD=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -lbfd
> +		FLAGS_BFD=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -lbfd -ldl
>  		has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD))
>  		ifeq ($(has_bfd),y)
> -			EXTLIBS += -lbfd
> +			EXTLIBS += -lbfd -ldl
>  		else
> -			FLAGS_BFD_IBERTY=$(FLAGS_BFD) -liberty
> +			FLAGS_BFD_IBERTY=$(FLAGS_BFD) -liberty -ldl

This is superfluous, because FLAGS_BFD has -ldl already by your change
above. This is cascaded downwards.

>  			has_bfd_iberty := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY))
>  			ifeq ($(has_bfd_iberty),y)
> -				EXTLIBS += -lbfd -liberty
> +				EXTLIBS += -lbfd -liberty -ldl
>  			else
> -				FLAGS_BFD_IBERTY_Z=$(FLAGS_BFD_IBERTY) -lz
> +				FLAGS_BFD_IBERTY_Z=$(FLAGS_BFD_IBERTY) -lz -ldl

Ditto.

>  				has_bfd_iberty_z := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY_Z))
>  				ifeq ($(has_bfd_iberty_z),y)
> -					EXTLIBS += -lbfd -liberty -lz
> +					EXTLIBS += -lbfd -liberty -lz -ldl
>  				else
>  					FLAGS_CPLUS_DEMANGLE=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -liberty
>  					has_cplus_demangle := $(call try-cc,$(SOURCE_CPLUS_DEMANGLE),$(FLAGS_CPLUS_DEMANGLE))

-- 
Markus
