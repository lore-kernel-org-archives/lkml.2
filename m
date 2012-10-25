Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934952Ab2JYIzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 04:55:10 -0400
Received: from mga07.intel.com ([143.182.124.22]:36270 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933482Ab2JYIzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 04:55:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLNyOufoekZCzvc0RyjbqzShAacnMMAuNab5AozTdM+Dw@mail.gmail.com>
References: <1351000104-13015-1-git-send-email-irina.tirdea@intel.com>
 <1351000104-13015-2-git-send-email-irina.tirdea@intel.com> <CAGXu5jLNyOufoekZCzvc0RyjbqzShAacnMMAuNab5AozTdM+Dw@mail.gmail.com>
From: "Tatulea, Dragos" <dragos.tatulea@intel.com>
Date: Thu, 25 Oct 2012 11:54:43 +0300
Message-ID: <CAJ_JQ2V=8htqwEL3tP9F3V2e1K_cni48jgYQCJa_QF1kE5wPEw@mail.gmail.com>
Subject: Re: [PATCH 01/26] pstore: allow for big files
To: Kees Cook <keescook@chromium.org>
Cc: Irina Tirdea <irina.tirdea@intel.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>,
        Chris Ball <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Octavian Purdila <octavian.purdila@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 7:48 PM, Kees Cook <keescook@chromium.org> wrote:
>
> On Tue, Oct 23, 2012 at 6:47 AM, Irina Tirdea <irina.tirdea@intel.com> wrote:
> > From: Adrian Hunter <adrian.hunter@intel.com>
> >
> > pstore reads all files into memory at mount time. To allow for back ends
> > that will store arbitrarily large files, enhance pstore also to be able
> > to read from the back end as needed.
> >
> > Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> > Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> > ---
> >  drivers/acpi/apei/erst.c |   16 +++++++++-------
> >  fs/pstore/inode.c        |   26 ++++++++++++++++++++------
> >  fs/pstore/internal.h     |    5 +++--
> >  fs/pstore/platform.c     |   11 +++++++----
> >  fs/pstore/ram.c          |   15 +++++++--------
> >  include/linux/pstore.h   |    7 +++++--
> >  6 files changed, 51 insertions(+), 29 deletions(-)
> >
> > diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
> > index e4d9d24..f70ba37 100644
> > --- a/drivers/acpi/apei/erst.c
> > +++ b/drivers/acpi/apei/erst.c
> > @@ -931,9 +931,9 @@ static int erst_check_table(struct acpi_table_erst *erst_tab)
> >
> >  static int erst_open_pstore(struct pstore_info *psi);
> >  static int erst_close_pstore(struct pstore_info *psi);
> > -static ssize_t erst_reader(u64 *id, enum pstore_type_id *type,
> > -                          struct timespec *time, char **buf,
> > -                          struct pstore_info *psi);
> > +static int erst_reader(u64 *id, enum pstore_type_id *type,
> > +                      struct timespec *time, char **buf, loff_t *size,
> > +                      struct pstore_info *psi);
> >  static int erst_writer(enum pstore_type_id type, enum kmsg_dump_reason reason,
> >                        u64 *id, unsigned int part,
> >                        size_t size, struct pstore_info *psi);
> > @@ -987,9 +987,9 @@ static int erst_close_pstore(struct pstore_info *psi)
> >         return 0;
> >  }
> >
> > -static ssize_t erst_reader(u64 *id, enum pstore_type_id *type,
> > -                          struct timespec *time, char **buf,
> > -                          struct pstore_info *psi)
> > +static int erst_reader(u64 *id, enum pstore_type_id *type,
> > +                      struct timespec *time, char **buf, loff_t *size,
> > +                      struct pstore_info *psi)
> >  {
> >         int rc;
> >         ssize_t len = 0;
> > @@ -1051,7 +1051,9 @@ skip:
> >
> >  out:
> >         kfree(rcd);
> > -       return (rc < 0) ? rc : (len - sizeof(*rcd));
> > +       if (!rc)
> > +               *size = len - sizeof(*rcd);
> > +       return rc;
> >  }
> >
> >  static int erst_writer(enum pstore_type_id type, enum kmsg_dump_reason reason,
> > diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
> > index 4ab572e..ff0970f 100644
> > --- a/fs/pstore/inode.c
> > +++ b/fs/pstore/inode.c
> > @@ -49,7 +49,8 @@ struct pstore_private {
> >         struct pstore_info *psi;
> >         enum pstore_type_id type;
> >         u64     id;
> > -       ssize_t size;
> > +       loff_t  size;
> > +       bool    big;
> >         char    data[];
> >  };
> >
> > @@ -65,12 +66,13 @@ static void *pstore_ftrace_seq_start(struct seq_file *s, loff_t *pos)
> >  {
> >         struct pstore_private *ps = s->private;
> >         struct pstore_ftrace_seq_data *data;
> > +       loff_t size = ps->size;
> >
> >         data = kzalloc(sizeof(*data), GFP_KERNEL);
> >         if (!data)
> >                 return NULL;
> >
> > -       data->off = ps->size % REC_SIZE;
> > +       data->off = do_div(size,  REC_SIZE);
>
> This modifies ps->size. I don't think you want that?
>
ps->size is not modified. The locally stored "size" variable is used
to avoid modifying ps->size.

Thanks,
Dragos
