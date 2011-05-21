Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab1EUQKm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 12:10:42 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:51323 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756529Ab1EUQKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 12:10:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=YjoYsNq2LDnLCYSTUmBp6jk7eW/Na7ztpow+M3jjB5mtqQbpj3l7bnLtAvuNA3+qfDPAoxybGb3DusiQIwinumxsQPZHgQ1yAWBL6MqUWhReSe9o1YNP63bJnX7VNqAT;
Date: Sat, 21 May 2011 09:10:37 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Subject: Re: [PATCH v4 1/3] PCI: Track the size of each saved capability
 data area
Message-ID: <20110521091037.6d2d78a9@jbarnes-e6510>
In-Reply-To: <20110510160204.3490.81034.stgit@s20.home>
References: <20110510155642.3490.61935.stgit@s20.home>
	<20110510160204.3490.81034.stgit@s20.home>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 May 2011 10:02:11 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> This will allow us to store and load it later.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
>  drivers/pci/pci.c   |   12 +++++++-----
>  include/linux/pci.h |   11 ++++++++---
>  2 files changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 2472e71..416930a 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -830,7 +830,7 @@ static int pci_save_pcie_state(struct pci_dev
> *dev) dev_err(&dev->dev, "buffer not found in %s\n", __func__);
>  		return -ENOMEM;
>  	}
> -	cap = (u16 *)&save_state->data[0];
> +	cap = (u16 *)&save_state->cap.data[0];
>  
>  	pci_read_config_word(dev, pos + PCI_EXP_FLAGS, &flags);
>  
> @@ -863,7 +863,7 @@ static void pci_restore_pcie_state(struct pci_dev
> *dev) pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
>  	if (!save_state || pos <= 0)
>  		return;
> -	cap = (u16 *)&save_state->data[0];
> +	cap = (u16 *)&save_state->cap.data[0];
>  
>  	pci_read_config_word(dev, pos + PCI_EXP_FLAGS, &flags);
>  
> @@ -899,7 +899,8 @@ static int pci_save_pcix_state(struct pci_dev
> *dev) return -ENOMEM;
>  	}
>  
> -	pci_read_config_word(dev, pos + PCI_X_CMD, (u16
> *)save_state->data);
> +	pci_read_config_word(dev, pos + PCI_X_CMD,
> +			     (u16 *)save_state->cap.data);
>  
>  	return 0;
>  }
> @@ -914,7 +915,7 @@ static void pci_restore_pcix_state(struct pci_dev
> *dev) pos = pci_find_capability(dev, PCI_CAP_ID_PCIX);
>  	if (!save_state || pos <= 0)
>  		return;
> -	cap = (u16 *)&save_state->data[0];
> +	cap = (u16 *)&save_state->cap.data[0];
>  
>  	pci_write_config_word(dev, pos + PCI_X_CMD, cap[i++]);
>  }
> @@ -1771,7 +1772,8 @@ static int pci_add_cap_save_buffer(
>  	if (!save_state)
>  		return -ENOMEM;
>  
> -	save_state->cap_nr = cap;
> +	save_state->cap.cap_nr = cap;
> +	save_state->cap.size = size;
>  	pci_add_saved_cap(dev, save_state);
>  
>  	return 0;
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 96f70d7..4dcb429 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -214,12 +214,17 @@ enum pci_bus_speed {
>  	PCI_SPEED_UNKNOWN		= 0xff,
>  };
>  
> -struct pci_cap_saved_state {
> -	struct hlist_node next;
> +struct pci_cap_saved_data {
>  	char cap_nr;
> +	unsigned int size;
>  	u32 data[0];
>  };
>  
> +struct pci_cap_saved_state {
> +	struct hlist_node next;
> +	struct pci_cap_saved_data cap;
> +};
> +
>  struct pcie_link_state;
>  struct pci_vpd;
>  struct pci_sriov;
> @@ -366,7 +371,7 @@ static inline struct pci_cap_saved_state
> *pci_find_saved_cap( struct hlist_node *pos;
>  
>  	hlist_for_each_entry(tmp, pos, &pci_dev->saved_cap_space,
> next) {
> -		if (tmp->cap_nr == cap)
> +		if (tmp->cap.cap_nr == cap)
>  			return tmp;
>  	}
>  	return NULL;

Applied these, thanks.
