Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab1CVXWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 19:22:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:41445 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755708Ab1CVXWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 19:22:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,228,1299484800"; 
   d="scan'208";a="616464008"
Date: Tue, 22 Mar 2011 16:22:46 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC] checkpatch: add option to change warning return value.
Message-ID: <20110322232246.GA7450@xanatos>
References: <20110322231310.GA7338@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110322231310.GA7338@xanatos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 04:13:10PM -0700, Sarah Sharp wrote:
> There are a lot of warnings in checkpatch.pl that are rather subjective.
> For instance, when a line is 81 characters long, and the patch submitter
> is just cleaning up existing code, a maintainer may not care that
> checkpatch.pl warns about the over 80-character line.  It should be up to
> the maintainer what warnings they want to pay attention to.
> 
> Unfortunately, if you try to run checkpatch.pl as part of a git pre-commit
> hook and a patch in a series being applied by git-am fails checkpatch.pl,
> the whole process stops.  At that point I usually end up just disabling
> that git hook, which means I don't see real errors in the patches.
> 
> Add an option to checkpatch.pl to print the warnings, but not return an
> error code when the --lazy flag is present.  (Anyone with a better name
> can pipe up, lazy just seemed to be the opposite to strict.)  This allows
> the maintainer to view the warnings, but still allow the patch application
> process to continue.

BTW, I'm not a perl hacker, and I don't really understand the reporting code,
so someone who knows it (Andy?) should make the correct patch.  I didn't notice
before sending, but right now the warning count reporting is bogus, although
the warnings don't make the script return an error code:

sarah@xanatos:~/git/kernels/xhci$ git am ~/Maildir.fetchmail/.to-apply/
Applying: USB: xhci - fix unsafe macro definitions
total: 0 errors, 0 warnings, 21 lines checked

Your patch has no obvious style problems and is ready for submission.
Applying: USB: xhci: unsigned char never equals -1
total: 0 errors, 0 warnings, 55 lines checked

Your patch has no obvious style problems and is ready for submission.
Applying: USB: xhci: simplify logic of skipping missed isoc TDs
WARNING: line over 80 characters
#12: FILE: drivers/usb/host/xhci-ring.c:1669:
+	struct xhci_ring *ep_ring = xhci_dma_to_transfer_ring(ep, event->buffer);

WARNING: line over 80 characters
#136: FILE: drivers/usb/host/xhci-ring.c:1743:
+	struct xhci_ring *ep_ring = xhci_dma_to_transfer_ring(ep, event->buffer);

WARNING: line over 80 characters
#164: FILE: drivers/usb/host/xhci-ring.c:1770:
+	struct xhci_ring *ep_ring = xhci_dma_to_transfer_ring(ep, event->buffer);

total: 0 errors, 0 warnings, 231 lines checked

Your patch has no obvious style problems and is ready for submission.
Applying: USB: fix formatting of SuperSpeed endpoints in /proc/bus/usb/devices
total: 0 errors, 0 warnings, 28 lines checked

Your patch has no obvious style problems and is ready for submission.


Note that second-to-last patch should have said 3 warnings.  So my patch needs
to be changed, but I really do want this functionality.

Sarah Sharp


> Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> ---
>  scripts/checkpatch.pl |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 4c0383d..4519b5b 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -15,6 +15,7 @@ my $V = '0.31';
>  use Getopt::Long qw(:config no_auto_abbrev);
>  
>  my $quiet = 0;
> +my $lazy = 0;
>  my $tree = 1;
>  my $chk_signoff = 1;
>  my $chk_patch = 1;
> @@ -46,6 +47,7 @@ Options:
>    --terse                    one line per report
>    -f, --file                 treat FILE as regular source file
>    --subjective, --strict     enable more subjective tests
> +  --lazy                     print warnings, but don't return an error condition
>    --root=PATH                PATH to the kernel tree root
>    --no-summary               suppress the per-file summary
>    --mailback                 only produce a report in case of warnings/errors
> @@ -80,6 +82,7 @@ GetOptions(
>  
>  	'debug=s'	=> \%debug,
>  	'test-only=s'	=> \$tst_only,
> +	'lazy+'		=> \$lazy,
>  	'h|help'	=> \$help,
>  	'version'	=> \$help
>  ) or help(1);
> @@ -1096,6 +1099,9 @@ sub report {
>  
>  	push(our @report, $line);
>  
> +	if ($lazy == 1) {
> +		return 0;
> +	}
>  	return 1;
>  }
>  sub report_dump {
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
