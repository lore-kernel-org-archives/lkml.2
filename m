Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab0JUFeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 01:34:01 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35072 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab0JUFeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 01:34:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nH93NKEu6U8qcbJQSTLTcPdgJtZ5Tx6EI/PLJVthORgVe/jwIiin+fflqtrd29lM6r
         iCbgxk5ATsvPjCJ2PmY8OWunCPVPlFWrVrvUbRJf+Nnt+0xq+FVnRRclAK3F5Y+nsKcU
         9KtQgj2z+urdNMIsZPnw6D/fUfHh0ODCVATBE=
Subject: Re: [tip:x86/mm] percpu: Introduce a read-mostly percpu API
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>
In-Reply-To: <20101021013833.GA21863@sli10-conroe.sh.intel.com>
References: <1287544022.4571.7.camel@sli10-conroe.sh.intel.com>
	 <tip-c957ef2c59e952803766ddc22e89981ab534606f@git.kernel.org>
	 <20101021013833.GA21863@sli10-conroe.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Oct 2010 07:33:50 +0200
Message-ID: <1287639230.2545.117.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 21 octobre 2010 à 09:38 +0800, Shaohua Li a écrit :
> Hi hpa,
> On Thu, Oct 21, 2010 at 07:06:59AM +0800, tip-bot for Shaohua Li wrote:
> > [ hpa: moved it *after* the page-aligned section, for obvious
> >   reasons. ]
> move it after page-aligned section can't guarantee to avoid cache false sharing.
> we need:
> . = ALIGN(CACHE_LINE_SIZE);
> *(.data..percpu..readmostly)
> . = ALIGN(CACHE_LINE_SIZE);
> To make sure before/after readmostly section doesn't share cache line with
> others. The headcache is some arch need L1_CACHE_SIZE and others need
> (1 << INTERNODE_CACHE_SHIFT). We need change all ARCHs to make this happen.

Really, readmostly percpu variables dont need INTERNODE_CACHE_SHIFT, as
this is read mostly, and per cpu vars ;)

Just use L1_CACHE_BYTES

                *(.data..percpu..first)                           \
                *(.data..percpu..page_aligned)                    \
+               . = ALIGN(L1_CACHE_BYTES                          \
+               *(.data..percpu..readmostly)                      \
+               . = ALIGN(L1_CACHE_BYTES                          \
                *(.data..percpu)                                  \


