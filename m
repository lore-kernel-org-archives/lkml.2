Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab0K1UJH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 15:09:07 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53676 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab0K1UJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 15:09:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=nXrfBeTaHKQ+SZuvyn4Kup8VV399UbKUdKrtAcjgyAAD6JrDwly5ofLTcf0EDYhEwh
         qjDwtGTpPhn81UXidIYUbKi+PFIfIA7CdUr9JptCNoN+OinJTkFr01qO6Fqcf3pkOMfP
         ivUzCGKmHJf8MaYfx/zjfD7OVMlMUDd82ASVU=
MIME-Version: 1.0
Date: Sun, 28 Nov 2010 21:09:03 +0100
Message-ID: <AANLkTikqds12LikuGfYZN-BKGsxPAwoehXRUZo_jBqd9@mail.gmail.com>
Subject: proc: proc_self_follow_link() weirdness
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I came across this code in fs/proc/base.c:

static void *proc_self_follow_link(struct dentry *dentry, struct nameidata *nd)
{
        struct pid_namespace *ns = dentry->d_sb->s_fs_info;
        pid_t tgid = task_tgid_nr_ns(current, ns);
        char *name = ERR_PTR(-ENOENT);
        if (tgid) {
                name = __getname();
                if (!name)
                        name = ERR_PTR(-ENOMEM);
                else
                        sprintf(name, "%d", tgid);
        }
        nd_set_link(nd, name);
        return NULL;
}

This looks a bit weird to me; it seems that nd_set_link() will get
called with name = ERR_PTR(-ENOMEM) if __getname() fails. Is this the
intended behaviour? Shouldn't it return this ERR_PTR() instead?


Vegard
