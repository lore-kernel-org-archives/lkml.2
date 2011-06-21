Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab1FUMqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 08:46:14 -0400
Received: from service87.mimecast.com ([94.185.240.25]:46127 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752019Ab1FUMqL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 08:46:11 -0400
Date: Tue, 21 Jun 2011 13:46:01 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH] Fix a memory leak reported by kmemleak.
Message-ID: <20110621124601.GE29146@e102109-lin.cambridge.arm.com>
References: <20110621110853.2537133.20464.stgit@localhost.localdomain>
MIME-Version: 1.0
In-Reply-To: <20110621110853.2537133.20464.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 21 Jun 2011 12:46:06.0020 (UTC) FILETIME=[2FBA0840:01CC3011]
X-MC-Unique: 111062113460802501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 12:08:53PM +0100, Bernd Schubert wrote:
> Memory allocated by get_current_resources() will be never free'ed
> if 'pci_use_crs' is not set.
> 
> Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
> ---
>  arch/x86/pci/acpi.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
> index 0972315..3ad040a 100644
> --- a/arch/x86/pci/acpi.c
> +++ b/arch/x86/pci/acpi.c
> @@ -228,8 +228,11 @@ static void add_resources(struct pci_root_info *info)
>  	int i;
>  	struct resource *res, *root, *conflict;
>  
> -	if (!pci_use_crs)
> +	if (!pci_use_crs) {
> +		kfree(info->res);
> +		kfree(info->name);
>  		return;
> +	}
>  
>  	coalesce_windows(info, IORESOURCE_MEM);
>  	coalesce_windows(info, IORESOURCE_IO);

Thanks for looking into this. I cc'ed Bjorn as he seems to be the last
one changing this file. I'm not familiar with part of the kernel, so not
sure whether info->res or info->name could be used somewhere else under
certain conditions.

An alternative patch (just to keep allocation/freeing in the same
function):

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 0972315..684cf82 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -228,9 +228,6 @@ static void add_resources(struct pci_root_info *info)
 	int i;
 	struct resource *res, *root, *conflict;
 
-	if (!pci_use_crs)
-		return;
-
 	coalesce_windows(info, IORESOURCE_MEM);
 	coalesce_windows(info, IORESOURCE_IO);
 
@@ -286,8 +283,11 @@ get_current_resources(struct acpi_device *device, int busnum,
 	acpi_walk_resources(device->handle, METHOD_NAME__CRS, setup_resource,
 				&info);
 
-	add_resources(&info);
-	return;
+	if (pci_use_crs) {
+		add_resources(&info);
+		return;
+	}
+	kfree(info.name);
 
 name_alloc_fail:
 	kfree(info.res);

-- 
Catalin

