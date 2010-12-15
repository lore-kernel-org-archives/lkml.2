Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab0LOMqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 07:46:38 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:49863 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab0LOMqh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 07:46:37 -0500
Date: Wed, 15 Dec 2010 18:16:43 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Christoph Hellwig <hch@lst.de>, Masami Hiramatsu <mhiramat@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch 18/21] Generate the data sections for ELF Core
Message-ID: <20101215181643.2c82c70f@suzukikp>
In-Reply-To: <4D086C1A.5000907@redhat.com>
References: <20101214152259.67896960@suzukikp>
	<20101214155200.06b56e57@suzukikp>
	<4D086C1A.5000907@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Dec 2010 15:19:54 +0800
Cong Wang <amwang@redhat.com> wrote:

> 于 2010年12月14日 18:22, Suzuki K. Poulose 写道:
> ...
> > +	/*
> > +	 * Read from the vma segments
> > +	 * a. verify if the *fpos is within a phdr
> > +	 * b. Use access_process_vm() to get data page by page
> > +	 * c. copy_to_user into user buffer
> > +	 */
> 
> 
> This kind of comments is useless, "code tells you how, comments tell you why."
> 
> 
> > +
> > +	while (buflen) {
> > +		size_t bufsz, offset, bytes;
> > +		char *readbuf;
> > +		struct elf_phdr *phdr = get_pos_elfphdr(cp, *fpos);
> > +
> > +		if (!phdr)
> > +			break;
> > +
> > +		bufsz = (buflen>  PAGE_SIZE) ? PAGE_SIZE : buflen;
> > +		readbuf = kmalloc(bufsz, GFP_KERNEL);
> > +		if (!readbuf) {
> > +			ret = -ENOMEM;
> > +			goto out;
> > +		}
> > +
> > +		offset = *fpos - phdr->p_offset;
> > +		bytes = access_process_vm(cp->task, (phdr->p_vaddr + offset),
> > +						readbuf, bufsz, 0);
> > +		if (!bytes) {
> > +			ret = -EIO;
> > +			goto out;
> 
> 
> Why you don't kfree(readbuf) here?
> 

I will add that.
> > +		}
> > +		if (copy_to_user(buffer, readbuf, bytes)) {
> > +			ret = -EFAULT;
> > +			kfree(readbuf);
> > +			goto out;
> > +		} else
> > +			acc += bytes;
> > +
> > +		kfree(readbuf);
> > +		buflen -= bytes;
> > +		buffer += bytes;
> > +		*fpos += bytes;
> > +	}
> > +
> > +	/* Fill extnum section header if present */
> > +	if (buflen&&
> > +		elf_hdr->e_shoff&&
> > +		(*fpos>= elf_hdr->e_shoff)&&
> > +		(*fpos<  (elf_hdr->e_shoff + sizeof(struct elf_shdr)))) {
> 
> 
> This indention seems ugly.

I will fix this.
> 
> > +
> > +		off_t offset = *fpos - elf_hdr->e_shoff;
> 
> Are you sure it is 'off_t' not 'loff_t'?
> 

You are right. I will change it
> > +		size_t shdrsz = sizeof(struct elf_shdr) - offset;
> > +
> > +		shdrsz = (buflen<  shdrsz) ? buflen : shdrsz;
> > +		if (copy_to_user(buffer, ((char *)cp->shdr) + offset, shdrsz)) {
> > +			ret = -EFAULT;
> > +			goto out;
> > +		} else {
> > +			acc += shdrsz;
> > +			buflen -= shdrsz;
> > +			buffer += shdrsz;
> > +		}
> > +	}
> >
> > +done:
> > +	ret = acc;
> >   out:
> >   	return ret;
> >   }
> 

Thank You !

Suzuki
> Thanks.

