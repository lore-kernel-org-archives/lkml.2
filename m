Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab1EIF45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 01:56:57 -0400
Received: from mail.perches.com ([173.55.12.10]:1361 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963Ab1EIF44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 01:56:56 -0400
Subject: kernel/param.c: add_sysfs_param memset?
From: Joe Perches <joe@perches.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 08 May 2011 22:56:55 -0700
Message-ID: <1304920615.19586.21.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks wrong to me.

static __modinit int add_sysfs_param(struct module_kobject *mk,
				     const struct kernel_param *kp,
				     const char *name)
{
	struct module_param_attrs *new;
	struct attribute **attrs;
[]
	if (!mk->mp) {
		num = 0;
		attrs = NULL;
	} else {
		num = mk->mp->num;
		attrs = mk->mp->grp.attrs;
	}

	/* Enlarge. */
[]
	attrs = krealloc(attrs, sizeof(new->grp.attrs[0])*(num+2), GFP_KERNEL);
[]
	memset(&attrs[num], 0, sizeof(attrs[num]));

sizeof(attrs[num]) is a pointer.

I presume this should be
	memset(&attrs[num], 0, sizeof(*attrs[num]));
or
	memset(&attrs[num], 0, sizeof(struct attribute));

If it's really just to set the pointer, a set to NULL is better.
	attrs[num] = NULL;

