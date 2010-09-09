Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab0IIUlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 16:41:51 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:45370 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752718Ab0IIUlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 16:41:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=cW7VqT6cs/7RBgpy/dtaILePnGoqTaqjSlvGckSrxk6W0EXpc1/qvnqapZeyyUGMyWRD06nZovjXILFSlObnOe4aHvItjffyRWQACt15t9RTn46gIZ+S6IyBriGa52mP;
Date: Thu, 9 Sep 2010 13:41:43 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Cam Macdonell <cam@cs.ualberta.ca>, Avi Kivity <avi@redhat.com>,
        "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Chris Wright <chrisw@redhat.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: fix pci_resource_alignment prototype
Message-ID: <20100909134143.59154112@jbarnes-desktop>
In-Reply-To: <20100908002520.GM30129@sequoia.sous-sol.org>
References: <AANLkTimk19OmkNYvVemxgyFfgByNDDq6R2fa6=FQ8H9L@mail.gmail.com>
	<4C83CA5A.7030404@redhat.com>
	<AANLkTimtATH7JvBRXBbnr0hJ5bFrtOa_3vsZRe4a_rfR@mail.gmail.com>
	<AANLkTim9EOUVuSq6Z3q6-j-x2w+JDD8F-_xH614uDFi8@mail.gmail.com>
	<AANLkTimGui3atGAa-FE=6JhF1rM7BU0xtN-T4mZKqD8_@mail.gmail.com>
	<20100908002520.GM30129@sequoia.sous-sol.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Sep 2010 17:25:20 -0700
Chris Wright <chrisw@sous-sol.org> wrote:

> From: Cam Macdonell <cam@cs.ualberta.ca>
> 
> * Cam Macdonell (cam@cs.ualberta.ca) wrote:
> > It seems it was the alignment value being passed back from
> > pci_resource_alignment().  The return type is an int, which was
> > causing value of 2GB to be sign extended to to 0xffffffff80000000.
> > Changing the return type to resource_size_t allows BAR values >= 2GB
> > to be successfully assigned.
> <snip>
> > -static inline int pci_resource_alignment(struct pci_dev *dev,
> > +static inline resource_size_t pci_resource_alignment(struct pci_dev *dev,
> >                                          struct resource *res)
> 
> Yes, that's my mistake.  Thanks for debugging the issue Cam.
> This fixes the prototype for both pci_resource_alignment() and
> pci_sriov_resource_alignment().
> 
> Patch started as debugging effort from Cam Macdonell.
> 
> Cc: Cam Macdonell <cam@cs.ualberta.ca>
> Cc: Avi Kivity <avi@redhat.com>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> [chrisw: add iov bits]
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> ---
>  drivers/pci/iov.c |    2 +-
>  drivers/pci/pci.h |    5 +++--
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> index ce6a366..553d8ee 100644
> --- a/drivers/pci/iov.c
> +++ b/drivers/pci/iov.c
> @@ -608,7 +608,7 @@ int pci_iov_resource_bar(struct pci_dev *dev, int resno,
>   * the VF BAR size multiplied by the number of VFs.  The alignment
>   * is just the VF BAR size.
>   */
> -int pci_sriov_resource_alignment(struct pci_dev *dev, int resno)
> +resource_size_t pci_sriov_resource_alignment(struct pci_dev *dev, int resno)
>  {
>  	struct resource tmp;
>  	enum pci_bar_type type;
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index 679c39d..5d0aeb1 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -262,7 +262,8 @@ extern int pci_iov_init(struct pci_dev *dev);
>  extern void pci_iov_release(struct pci_dev *dev);
>  extern int pci_iov_resource_bar(struct pci_dev *dev, int resno,
>  				enum pci_bar_type *type);
> -extern int pci_sriov_resource_alignment(struct pci_dev *dev, int resno);
> +extern resource_size_t pci_sriov_resource_alignment(struct pci_dev *dev,
> +						    int resno);
>  extern void pci_restore_iov_state(struct pci_dev *dev);
>  extern int pci_iov_bus_range(struct pci_bus *bus);
>  
> @@ -318,7 +319,7 @@ static inline int pci_ats_enabled(struct pci_dev *dev)
>  }
>  #endif /* CONFIG_PCI_IOV */
>  
> -static inline int pci_resource_alignment(struct pci_dev *dev,
> +static inline resource_size_t pci_resource_alignment(struct pci_dev *dev,
>  					 struct resource *res)
>  {
>  #ifdef CONFIG_PCI_IOV
> 
> 

Applied to my for-linus branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
