Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab2ADAzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 19:55:35 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:33385 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754855Ab2ADAzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 19:55:33 -0500
X-Sasl-enc: 2TTeAwRjp99uWYIQelJhgv3dEqnKgj+1GgQNWhkKZqfL 1325638532
Date: Tue, 3 Jan 2012 16:55:27 -0800
From: Greg KH <greg@kroah.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Alessandro Rubini <rubini@gnudd.com>
Subject: Re: [PATCH -next] debugfs: add missing #ifdef HAS_IOMEM
Message-ID: <20120104005527.GA29102@kroah.com>
References: <1324994908-4288-1-git-send-email-heiko.carstens@de.ibm.com>
 <20120104004452.GA22949@kroah.com>
 <20120104004823.GC23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120104004823.GC23916@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 12:48:23AM +0000, Al Viro wrote:
> On Tue, Jan 03, 2012 at 04:44:52PM -0800, Greg KH wrote:
> > On Tue, Dec 27, 2011 at 03:08:28PM +0100, Heiko Carstens wrote:
> > > "debugfs: add tools to printk 32-bit registers" adds new functions which rely
> > > on IOMEM functionality which is not present on all architectures and therefore
> > > result in compile errors:
> > > 
> > > fs/debugfs/file.c: In function 'debugfs_print_regs32':
> > > fs/debugfs/file.c:561:7: error: implicit declaration of function 'readl' [-Werror=implicit-function-declaration]
> > 
> > Who does not have readl()?  Surely there should be a .h file we are just
> > missing to include?
> 
> s390, uml, etc.  What the hell is that kind of stuff doing in fs/*/*, anyway?

It's a debugfs "helper" function, included below, consolidating a number
of duplicated versions of this in other places in the kernel that were
doing the same thing.

thanks,

greg k-h


/**
 * debugfs_print_regs32 - use seq_print to describe a set of registers
 * @s: the seq_file structure being used to generate output
 * @regs: an array if struct debugfs_reg32 structures
 * @mregs: the length of the above array
 * @base: the base address to be used in reading the registers
 * @prefix: a string to be prefixed to every output line
 *
 * This function outputs a text block describing the current values of
 * some 32-bit hardware registers. It is meant to be used within debugfs
 * files based on seq_file that need to show registers, intermixed with other
 * information. The prefix argument may be used to specify a leading string,
 * because some peripherals have several blocks of identical registers,
 * for example configuration of dma channels
 */
int debugfs_print_regs32(struct seq_file *s, const struct debugfs_reg32 *regs,
                           int nregs, void __iomem *base, char *prefix)
{
        int i, ret = 0;

        for (i = 0; i < nregs; i++, regs++) {
                if (prefix)
                        ret += seq_printf(s, "%s", prefix);
                ret += seq_printf(s, "%s = 0x%08x\n", regs->name,
                                  readl(base + regs->offset));
        }
        return ret;
}
EXPORT_SYMBOL_GPL(debugfs_print_regs32);

