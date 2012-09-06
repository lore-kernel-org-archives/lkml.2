Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab2IFObK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 10:31:10 -0400
Received: from mga07.intel.com ([143.182.124.22]:22210 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754879Ab2IFObI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 10:31:08 -0400
Subject: Re: [RFC,PATCH v2] efi: Add support for a UEFI variable filesystem
From: Matt Fleming <matt.fleming@intel.com>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Matt Domsch <Matt_Domsch@Dell.com>,
        Peter Jones <pjones@redhat.com>
In-Reply-To: <5048B1E8.1020904@canonical.com>
References: <1346910035.47691.188651047712.1.gpush@pecola>
	 <1346941120.4244.82.camel@mfleming-mobl1.ger.corp.intel.com>
	 <5048B1E8.1020904@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Thu, 06 Sep 2012 15:30:51 +0100
Message-ID: <1346941851.4244.87.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Cc'ing Peter Jones who wrote a auth deletion patch for efivars)

On Thu, 2012-09-06 at 22:23 +0800, Jeremy Kerr wrote:
> Hi Matt,
> 
> > Am I correct in thinking that this filesystem doesn't handle deletion of
> > authenticated variables?
> 
> Unless I'm missing something, this should work fine; we just pass the 
> EFI_VARIABLE_AUTHENTICATION_2 descriptor (with the usual attribute 
> header), but no data following the descriptor.

I think this is the problematic chunk of code,

static int efivars_unlink(struct inode *dir, struct dentry *dentry)             
{                                                                               
        struct efivar_entry *var = dentry->d_inode->i_private;                  
        struct efivars *efivars = var->efivars;                                 
        efi_status_t status;                                                    
                                                                                
        spin_lock(&efivars->lock);                                              
                                                                                
        status = efivars->ops->set_variable(var->var.VariableName,              
                                            &var->var.VendorGuid,               
                                            0, 0, NULL);                        

For deleting authenticated variables Attributes, DataSize and Data need
to be non-zero. I think DataSize == AuthInfo descriptor. Peter?

