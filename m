Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab2JWQsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 12:48:30 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61004 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138Ab2JWQs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 12:48:29 -0400
MIME-Version: 1.0
In-Reply-To: <1351000104-13015-2-git-send-email-irina.tirdea@intel.com>
References: <1351000104-13015-1-git-send-email-irina.tirdea@intel.com>
	<1351000104-13015-2-git-send-email-irina.tirdea@intel.com>
Date: Tue, 23 Oct 2012 09:48:27 -0700
X-Google-Sender-Auth: UgsaQbHr6VI8obYcaQIIiwEEEWw
Message-ID: <CAGXu5jLNyOufoekZCzvc0RyjbqzShAacnMMAuNab5AozTdM+Dw@mail.gmail.com>
Subject: Re: [PATCH 01/26] pstore: allow for big files
From: Kees Cook <keescook@chromium.org>
To: Irina Tirdea <irina.tirdea@intel.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, Chris Ball <cjb@laptop.org>,
        linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Octavian Purdila <octavian.purdila@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 6:47 AM, Irina Tirdea <irina.tirdea@intel.com> wrote:
> From: Adrian Hunter <adrian.hunter@intel.com>
>
> pstore reads all files into memory at mount time. To allow for back ends
> that will store arbitrarily large files, enhance pstore also to be able
> to read from the back end as needed.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> ---
>  drivers/acpi/apei/erst.c |   16 +++++++++-------
>  fs/pstore/inode.c        |   26 ++++++++++++++++++++------
>  fs/pstore/internal.h     |    5 +++--
>  fs/pstore/platform.c     |   11 +++++++----
>  fs/pstore/ram.c          |   15 +++++++--------
>  include/linux/pstore.h   |    7 +++++--
>  6 files changed, 51 insertions(+), 29 deletions(-)
>
> diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
> index e4d9d24..f70ba37 100644
> --- a/drivers/acpi/apei/erst.c
> +++ b/drivers/acpi/apei/erst.c
> @@ -931,9 +931,9 @@ static int erst_check_table(struct acpi_table_erst *erst_tab)
>
>  static int erst_open_pstore(struct pstore_info *psi);
>  static int erst_close_pstore(struct pstore_info *psi);
> -static ssize_t erst_reader(u64 *id, enum pstore_type_id *type,
> -                          struct timespec *time, char **buf,
> -                          struct pstore_info *psi);
> +static int erst_reader(u64 *id, enum pstore_type_id *type,
> +                      struct timespec *time, char **buf, loff_t *size,
> +                      struct pstore_info *psi);
>  static int erst_writer(enum pstore_type_id type, enum kmsg_dump_reason reason,
>                        u64 *id, unsigned int part,
>                        size_t size, struct pstore_info *psi);
> @@ -987,9 +987,9 @@ static int erst_close_pstore(struct pstore_info *psi)
>         return 0;
>  }
>
> -static ssize_t erst_reader(u64 *id, enum pstore_type_id *type,
> -                          struct timespec *time, char **buf,
> -                          struct pstore_info *psi)
> +static int erst_reader(u64 *id, enum pstore_type_id *type,
> +                      struct timespec *time, char **buf, loff_t *size,
> +                      struct pstore_info *psi)
>  {
>         int rc;
>         ssize_t len = 0;
> @@ -1051,7 +1051,9 @@ skip:
>
>  out:
>         kfree(rcd);
> -       return (rc < 0) ? rc : (len - sizeof(*rcd));
> +       if (!rc)
> +               *size = len - sizeof(*rcd);
> +       return rc;
>  }
>
>  static int erst_writer(enum pstore_type_id type, enum kmsg_dump_reason reason,
> diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
> index 4ab572e..ff0970f 100644
> --- a/fs/pstore/inode.c
> +++ b/fs/pstore/inode.c
> @@ -49,7 +49,8 @@ struct pstore_private {
>         struct pstore_info *psi;
>         enum pstore_type_id type;
>         u64     id;
> -       ssize_t size;
> +       loff_t  size;
> +       bool    big;
>         char    data[];
>  };
>
> @@ -65,12 +66,13 @@ static void *pstore_ftrace_seq_start(struct seq_file *s, loff_t *pos)
>  {
>         struct pstore_private *ps = s->private;
>         struct pstore_ftrace_seq_data *data;
> +       loff_t size = ps->size;
>
>         data = kzalloc(sizeof(*data), GFP_KERNEL);
>         if (!data)
>                 return NULL;
>
> -       data->off = ps->size % REC_SIZE;
> +       data->off = do_div(size,  REC_SIZE);

This modifies ps->size. I don't think you want that?

-Kees

>         data->off += *pos * REC_SIZE;
>         if (data->off + REC_SIZE > ps->size) {
>                 kfree(data);
> @@ -127,6 +129,12 @@ static ssize_t pstore_file_read(struct file *file, char __user *userbuf,
>
>         if (ps->type == PSTORE_TYPE_FTRACE)
>                 return seq_read(file, userbuf, count, ppos);
> +       if (ps->big) {
> +               if (ps->psi->file_read)
> +                       return ps->psi->file_read(ps->id, ps->type, userbuf,
> +                                               count, ppos, ps->psi);
> +               return -EFBIG;
> +       }
>         return simple_read_from_buffer(userbuf, count, ppos, ps->data, ps->size);
>  }
>
> @@ -271,8 +279,8 @@ int pstore_is_mounted(void)
>   * Set the mtime & ctime to the date that this record was originally stored.
>   */
>  int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id,
> -                 char *data, size_t size, struct timespec time,
> -                 struct pstore_info *psi)
> +                 char *data, loff_t size, struct timespec time,
> +                 struct pstore_info *psi, bool big)
>  {
>         struct dentry           *root = pstore_sb->s_root;
>         struct dentry           *dentry;
> @@ -281,6 +289,7 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id,
>         char                    name[PSTORE_NAMELEN];
>         struct pstore_private   *private, *pos;
>         unsigned long           flags;
> +       size_t                  inline_size;
>
>         spin_lock_irqsave(&allpstore_lock, flags);
>         list_for_each_entry(pos, &allpstore, list) {
> @@ -301,12 +310,17 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id,
>                 goto fail;
>         inode->i_mode = S_IFREG | 0444;
>         inode->i_fop = &pstore_file_operations;
> -       private = kmalloc(sizeof *private + size, GFP_KERNEL);
> +       if (big)
> +               inline_size = 0;
> +       else
> +               inline_size = size;
> +       private = kmalloc(sizeof(*private) + inline_size, GFP_KERNEL);
>         if (!private)
>                 goto fail_alloc;
>         private->type = type;
>         private->id = id;
>         private->psi = psi;
> +       private->big = big;
>
>         switch (type) {
>         case PSTORE_TYPE_DMESG:
> @@ -336,7 +350,7 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id,
>         if (IS_ERR(dentry))
>                 goto fail_lockedalloc;
>
> -       memcpy(private->data, data, size);
> +       memcpy(private->data, data, inline_size);
>         inode->i_size = private->size = size;
>
>         inode->i_private = private;
> diff --git a/fs/pstore/internal.h b/fs/pstore/internal.h
> index 4847f58..f840159 100644
> --- a/fs/pstore/internal.h
> +++ b/fs/pstore/internal.h
> @@ -50,8 +50,9 @@ extern struct pstore_info *psinfo;
>  extern void    pstore_set_kmsg_bytes(int);
>  extern void    pstore_get_records(int);
>  extern int     pstore_mkfile(enum pstore_type_id, char *psname, u64 id,
> -                             char *data, size_t size,
> -                             struct timespec time, struct pstore_info *psi);
> +                             char *data, loff_t size,
> +                             struct timespec time, struct pstore_info *psi,
> +                             bool big);
>  extern int     pstore_is_mounted(void);
>
>  #endif
> diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
> index a40da07..108bd69 100644
> --- a/fs/pstore/platform.c
> +++ b/fs/pstore/platform.c
> @@ -264,7 +264,7 @@ void pstore_get_records(int quiet)
>  {
>         struct pstore_info *psi = psinfo;
>         char                    *buf = NULL;
> -       ssize_t                 size;
> +       loff_t                  size;
>         u64                     id;
>         enum pstore_type_id     type;
>         struct timespec         time;
> @@ -277,9 +277,12 @@ void pstore_get_records(int quiet)
>         if (psi->open && psi->open(psi))
>                 goto out;
>
> -       while ((size = psi->read(&id, &type, &time, &buf, psi)) > 0) {
> -               rc = pstore_mkfile(type, psi->name, id, buf, (size_t)size,
> -                                 time, psi);
> +       while (1) {
> +               rc = psi->read(&id, &type, &time, &buf, &size, psi);
> +               if (rc && rc != -EFBIG)
> +                       break;
> +               rc = pstore_mkfile(type, psi->name, id, buf, size,
> +                                 time, psi, rc == -EFBIG);
>                 kfree(buf);
>                 buf = NULL;
>                 if (rc && (rc != -EEXIST || !quiet))
> diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
> index 1a4f6da..dd47a87 100644
> --- a/fs/pstore/ram.c
> +++ b/fs/pstore/ram.c
> @@ -131,12 +131,11 @@ ramoops_get_next_prz(struct persistent_ram_zone *przs[], uint *c, uint max,
>         return prz;
>  }
>
> -static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
> +static int ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
>                                    struct timespec *time,
> -                                  char **buf,
> +                                  char **buf, loff_t *size,
>                                    struct pstore_info *psi)
>  {
> -       ssize_t size;
>         struct ramoops_context *cxt = psi->data;
>         struct persistent_ram_zone *prz;
>
> @@ -150,19 +149,19 @@ static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
>                 prz = ramoops_get_next_prz(&cxt->fprz, &cxt->ftrace_read_cnt,
>                                            1, id, type, PSTORE_TYPE_FTRACE, 0);
>         if (!prz)
> -               return 0;
> +               return -EINVAL;
>
>         /* TODO(kees): Bogus time for the moment. */
>         time->tv_sec = 0;
>         time->tv_nsec = 0;
>
> -       size = persistent_ram_old_size(prz);
> -       *buf = kmalloc(size, GFP_KERNEL);
> +       *size = persistent_ram_old_size(prz);
> +       *buf = kmalloc(*size, GFP_KERNEL);
>         if (*buf == NULL)
>                 return -ENOMEM;
> -       memcpy(*buf, persistent_ram_old(prz), size);
> +       memcpy(*buf, persistent_ram_old(prz), *size);
>
> -       return size;
> +       return 0;
>  }
>
>  static size_t ramoops_write_kmsg_hdr(struct persistent_ram_zone *prz)
> diff --git a/include/linux/pstore.h b/include/linux/pstore.h
> index ee3034a..3a293ff 100644
> --- a/include/linux/pstore.h
> +++ b/include/linux/pstore.h
> @@ -49,8 +49,11 @@ struct pstore_info {
>         struct mutex    read_mutex;     /* serialize open/read/close */
>         int             (*open)(struct pstore_info *psi);
>         int             (*close)(struct pstore_info *psi);
> -       ssize_t         (*read)(u64 *id, enum pstore_type_id *type,
> -                       struct timespec *time, char **buf,
> +       int             (*read)(u64 *id, enum pstore_type_id *type,
> +                       struct timespec *time, char **buf, loff_t *size,
> +                       struct pstore_info *psi);
> +       ssize_t         (*file_read)(u64 id, enum pstore_type_id type,
> +                       char __user *userbuf, size_t count, loff_t *ppos,
>                         struct pstore_info *psi);
>         int             (*write)(enum pstore_type_id type,
>                         enum kmsg_dump_reason reason, u64 *id,
> --
> 1.7.9.5
>



-- 
Kees Cook
Chrome OS Security
