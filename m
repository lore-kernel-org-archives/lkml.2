Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab0FCXrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 19:47:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60281 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756733Ab0FCXrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 19:47:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 4/5] BKL: use no BKL in llseek
Date: Fri, 4 Jun 2010 01:47:26 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.35-rc1-00090-g358f4b6; KDE/4.4.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jan Blunck <jblunck@suse.de>, Julia Lawall <julia@diku.dk>
References: <1275523999-27462-1-git-send-email-arnd@arndb.de> <1275523999-27462-5-git-send-email-arnd@arndb.de> <20100603070608.GA12123@infradead.org>
In-Reply-To: <20100603070608.GA12123@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006040147.27070.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19f8y1YKZZm1tnfwS/i0NWfhvFwQGqVfm6wUnm
 Lwa2Vf28dHx/fUpOYDr6CMy9InxT1xm3H+NNwPsIIf59YOuaW8
 sZrQ9JlXhIHrVztwXD/vA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 June 2010 09:06:08 Christoph Hellwig wrote:
> On Thu, Jun 03, 2010 at 02:13:18AM +0200, Arnd Bergmann wrote:
> > We have shown that the BKL in default_llseek and other
> > llseek operations never protects against concurrent access
> > from another function:
> 
> From VFS POV no to the default_llseek conversion.  As told you and
> others of the BKL brigade don't change this thing but get rid of it
> entirely.  I was under the impression we had agreed on a road map
> for that anyway.  Please don't forget that overall kernel improvement
> should at least be a side effect of your big sweap and clean.

Well, the two things (killing the BKL and killing default_llseek)
are not as related as make it appear: as I've shown, nothing that
currently implicitly uses default_llseek depends on the BKL,
so we could kill them in either order.

Nevertheless, you are right that default_llseek needs to go as well,
and I've put some effort into this. This is a coccinelle patch
that tries to find the correct llseek method for each file_operation
(default_llseek, no_llseek, noop_llseek). It does not find the
correct answer in each case, and is likely much more complicated
than it needs to be.

Julia, can you take a look? This currently outputs more than
one .llseek= line for some operations and fails to make detect
some cases that I think it should find.

	Arnd

---
@ open1 @
identifier nested_open;
identifier nso ~= "nonseekable_open";
@@
nested_open(...)
{
...
nso(...)
...
}

@ open @
identifier open_f;
identifier i, f;
identifier nso ~= "nonseekable_open";
identifier open1.nested_open;
@@
int open_f(struct inode *i, struct file *f)
{
...
(
nso(...)
|
nested_open(...)
)
...
}

@ read @
identifier read_f;
identifier f, p, s, off;
type ssize_t, size_t, loff_t;
expression E;
identifier func;
@@
ssize_t read_f(struct file *f, char *p, size_t s, loff_t *off)
{
(
... *off = E...
|
... func(..., off, ...) ...
|
... E = *off ...
)
}

@ read_no_fpos @
identifier read_f;
identifier f, p, s, off;
type ssize_t, size_t, loff_t;
@@
ssize_t read_f(struct file *f, char *p, size_t s, loff_t *off)
{
... when != off
}

@ write @
identifier write_f;
identifier f, p, s, off;
type ssize_t, size_t, loff_t;
expression E;
identifier func;
@@
ssize_t write_f(struct file *f, const char *p, size_t s, loff_t *off)
{
... *off = E...
|
... func(..., off, ...) ...
|
... E = *off ...
)
}

@ write_no_fpos @
identifier write_f;
identifier f, p, s, off;
type ssize_t, size_t, loff_t;
@@
ssize_t write_f(struct file *f, const char *p, size_t s, loff_t *off)
{
... when != off
}

@ fops0 @
identifier fops;
@@
struct file_operations fops = {
 ...
};

@ has_llseek depends on fops0 @
identifier fops0.fops;
identifier llseek_f;
@@
struct file_operations fops = {
... 
 .llseek = llseek_f,
...
};

@ has_read depends on fops0 @
identifier fops0.fops;
identifier read_f;
@@
struct file_operations fops = {
... 
 .read = read_f,
...
};

@ has_write depends on fops0 @
identifier fops0.fops;
identifier write_f;
@@
struct file_operations fops = {
... 
 .write = write_f,
...
};

@ has_open depends on fops0 @
identifier fops0.fops;
identifier open_f;
@@
struct file_operations fops = {
... 
 .open = open_f,
...
};

// does not work properly -- this always matches...
@ nonseekable1 depends on !has_llseek && has_open @
identifier fops;
identifier nso ~= "nonseekable_open";
@@
// fops directly use nonseekable_open
struct file_operations fops = {
...  .open = nso, ...
+.llseek = no_llseek, /* nonseekable */
};

@ nonseekable2 depends on !has_llseek @
identifier fops;
identifier open.open_f;
@@
// fops use open which calls nonseekable_open
struct file_operations fops = {
...  .open = open_f, ...
+.llseek = no_llseek, /* open uses nonseekable */
};

@ fops1 depends on !has_llseek && !nonseekable2 @
identifier fops0.fops;
identifier read.read_f;
identifier readdir_e;
@@
(
// read fops use offset
struct file_operations fops = {
... .read = read_f, ...
+.llseek = default_llseek, /* read accesses f_pos */
};
|
// any other fop is used that changes pos
struct file_operations fops = {
... .readdir = readdir_e, ...
+.llseek = default_llseek, /* readdir is present */
};
)

@ fops2 depends on !fops1 && !has_llseek && !nonseekable2 @
identifier fops0.fops;
identifier write.write_f;
@@
// write fops use offset
struct file_operations fops = {
... .write = write_f, ...
+	.llseek = default_llseek, /* write accesses f_pos */
};

@ fops3 depends on !fops1 && !fops2 && !has_llseek && !nonseekable2 @
identifier fops;
identifier read_no_fpos.read_f;
identifier write_no_fpos.write_f;
@@
// write fops use offset
struct file_operations fops = {
... 
 .write = write_f,
 .read = read_f,
...
+.llseek = noop_llseek, /* read and write both use no f_pos */
};

@ depends on has_write && !has_read && !fops1 && !fops2 && !has_llseek && nonseekable2 @
identifier fops0.fops;
identifier write_no_fpos.write_f;
@@
struct file_operations fops = {
... .write = write_f, ...
+.llseek = noop_llseek, /* write uses no f_pos */
};

@ depends on has_read && !has_write && !fops1 && !fops2 && !has_llseek && !nonseekable2 @
identifier fops0.fops;
identifier read_no_fpos.read_f;
@@
struct file_operations fops = {
... .read = read_f, ...
+.llseek = noop_llseek, /* read uses no f_pos */
};

@ depends on !has_read && !has_write && !fops1 && !fops2 && !has_llseek && !nonseekable2@
identifier fops0.fops;
@@
struct file_operations fops = {
...
+.llseek = noop_llseek, /* no read or write fn */
};
