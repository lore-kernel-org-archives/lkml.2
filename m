Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191Ab1ANSTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 13:19:17 -0500
Received: from mail.perches.com ([173.55.12.10]:3168 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758172Ab1ANSTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 13:19:08 -0500
Subject: Re: [PATCH] Proposal to add dynamic debug feature for
 print_hex_dump
From: Joe Perches <realty@perches.com>
To: Roman Fietze <roman.fietze@telemotive.de>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <201101140943.53142.roman.fietze@telemotive.de>
References: <201012031517.35062.roman.fietze@telemotive.de>
	 <201012061113.01576.roman.fietze@telemotive.de>
	 <1291822758.1240.8.camel@Joe-Laptop>
	 <201101140943.53142.roman.fietze@telemotive.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Jan 2011 10:19:06 -0800
Message-ID: <1295029146.4099.71.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-14 at 09:43 +0100, Roman Fietze wrote:
> Comments are again welcome.
> Add macros e.g. named pr_<level>_hex_dump calling print_hex_dump with
> the approriate level, with level being emerg, alert, ..., debug. This
> is similiar to the functions starting with "pr_".

Here's a count of the current print_hex_dump uses:

$ grep -rP --include=*.[ch] -oh "print_hex_dump\s*\(\s*KERN_[A-Z]+" * | \
  grep -oh -P "KERN_[A-Z]+" | sort | uniq -c
      1 KERN_ALERT
      2 KERN_CONT
     55 KERN_DEBUG
     44 KERN_ERR
     27 KERN_INFO
     10 KERN_WARNING

A high percentage of these print_hex_dump() uses are
(,,, 16, 1, buf, len, true) so there's some value
in doing this.

Converting all of these uses to this new style will
not be possible.

I suggest simplifying naming to just hex_dump_<level>.

That mirrors the more common prefix_<level> style
(dev_<level>, netdev_<level>, etc) and a few more
uses of a single line of code would be possible.

Adding a hex_dump_printk function to hexdump.c

void hex_dump_printk(const char *level, const char *prefix_str, int prefix_type,
		     const void *buf, size_t len)
{
	print_hex_dump(level, prefix_str, prefix_type, 16, 1,
		       buf, len, true);
}

Removing the print_hex_dump_bytes function and adding

#define print_hex_dump_bytes(prefix, type, buf, len) \
	hex_dump_printk(KERN_DEBUG, prefix, type, buf, len)

Adding macros for the various levels:

#define hex_dump_emerg(prefix, type, buf, len)		\
	hex_dump_printk(KERN_EMERG, prefix, type, len)
#define hex_dump_alert(prefix, type, buf, len)		\
	hex_dump_printk(KERN_ALERT, prefix, type, len)
#define hex_dump_crit(prefix, type, buf, len)		\
	hex_dump_printk(KERN_CRIT, prefix, type, len)
#define hex_dump_err(prefix, type, buf, len)		\
	hex_dump_printk(KERN_ERR, prefix, type, len)
#define hex_dump_warn(prefix, type, buf, len)		\
	hex_dump_printk(KERN_WARNING, prefix, type, len)
#define hex_dump_notice(prefix, type, buf, len)		\
	hex_dump_printk(KERN_NOTICE, prefix, type, len)
#define hex_dump_info(prefix, type, buf, len)		\
	hex_dump_printk(KERN_INFO, prefix, type, len)
#define hex_dump_cont(prefix, type, buf, len)		\
	hex_dump_printk(KERN_CONT, prefix, type, len)

> Use dynamic printk wrapper to support turning pr_debug_hex_dump on and
> off similar to pr_debug using the dynamic debug sysfs control file.

And add and use a #define hex_dump_dbg with
with dynamic_hex_dump_dbg as appropriate.

Lastly, the 20 or so print_hex_dump_bytes
uses could be converted to hex_dump_dbg()
if desired.

cheers, Joe

