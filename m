Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031833Ab2CPISY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 04:18:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:22667 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965438Ab2CPIRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 04:17:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="139818053"
Message-ID: <4F62F73A.6020108@intel.com>
Date: Fri, 16 Mar 2012 10:18:02 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Seiji Aguchi <seiji.aguchi@hds.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Chen Gong (gong.chen@linux.intel.com)" <gong.chen@linux.intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [Patch]Fix reason_str of pstore so that it can work correctly
References: <5C4C569E8A4B9B42A84A977CF070A35B2DACC35686@USINDEVS01.corp.hds.com>
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2DACC35686@USINDEVS01.corp.hds.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/12 23:17, Seiji Aguchi wrote:
> Hi,
> 
> Recently, there has been some changes in kmsg_dump() below.
>  (1) kmsg_dump(KMSG_DUMP_KEXEC) was removed.
>      http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=a3dd3323058d281abd584b15ad4c5b65064d7a61
> 
>  (2) A order of "enum kmsg_dump_reason" was modified.
>      http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=c22ab332902333f83766017478c1ef6607ace681
> 
>  These above patches modified kmsg_dump_reason in include/linux/kmsg_dump.h. 
>  But reason_str in fs/pstore/platform.c was not modified.
> 
>  This patch just fixes reason_str in fs/pstore/platform.c so that pstore can work correctly.
> 
>  Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
> 
> ---
>  fs/pstore/platform.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c index 9ec22d3..81f4748 100644
> --- a/fs/pstore/platform.c
> +++ b/fs/pstore/platform.c
> @@ -69,7 +69,7 @@ void pstore_set_kmsg_bytes(int bytes)
>  static int	oopscount;
>  
>  static char *reason_str[] = {
> -	"Oops", "Panic", "Kexec", "Restart", "Halt", "Poweroff", "Emergency"
> +	"Panic", "Oops", "Emergency", "Restart", "Halt", "Poweroff"
>  };

It would be better to make it so it would not break e.g.

static const char *get_reason_str(enum kmsg_dump_reason reason) {
	switch (reason) {
	KMSG_DUMP_PANIC:
		return "Panic";
	KMSG_DUMP_OOPS:
		return "Oops";
	KMSG_DUMP_EMERG:
		return "Emergency";
	KMSG_DUMP_RESTART:
		return "Restart";
	KMSG_DUMP_HALT:
		return "Halt";
	KMSG_DUMP_POWEROFF:
		return "Poweroff";
	default:
		return "Unknown";
	}
}
