Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260Ab2DFWP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 18:15:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9053 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758233Ab2DFWP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 18:15:57 -0400
X-Authority-Analysis: v=2.0 cv=Z8Fu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=_FBgzLvS3gEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=20KFwNOVAAAA:8 a=9KS4lHk-9LMMqJHZZrsA:9 a=LzXNEvAJhK0YgP2O5a4A:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=MrnTFEqonF5lhrNx:21 a=qhhdL4w7kVKRkeTi:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 02/15] tools/events: Add files to create libtraceevent.a
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Arun Sharma <asharma@fb.com>,
        Namhyung Kim <namhyung.kim@lge.com>
In-Reply-To: <20120406132158.GG30425@liondog.tnic>
References: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>
	 <1333666086-6517-3-git-send-email-fweisbec@gmail.com>
	 <20120406132158.GG30425@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Apr 2012 18:15:44 -0400
Message-ID: <1333750544.2920.6.camel@acer.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-06 at 15:21 +0200, Borislav Petkov wrote:

> <snip>
> 
> Btw, running this through checkpatch generates a load of warnings/errors
> and some of them actually could be worth fixing...

Yeah, there were patches I added without running checkpatch (in the
trace-cmd code).

> 
> > diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> > new file mode 100644
> > index 0000000..47a3227
> > --- /dev/null
> > +++ b/tools/lib/traceevent/event-parse.c
> > @@ -0,0 +1,4971 @@
> > +/*
> > + * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
> > + *
> > + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU Lesser General Public
> > + * License as published by the Free Software Foundation;
> > + * version 2.1 of the License (not later!)
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU Lesser General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU Lesser General Public
> > + * License along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
> > + *
> > + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > + *
> > + *  The parts for function graph printing was taken and modified from the
> > + *  Linux Kernel that were written by
> > + *    - Copyright (C) 2009  Frederic Weisbecker,
> > + *  Frederic Weisbecker gave his permission to relicense the code to
> > + *  the Lesser General Public License.
> > + */
> > +#define _GNU_SOURCE
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <string.h>
> > +#include <stdarg.h>
> > +#include <ctype.h>
> > +#include <errno.h>
> > +
> > +#include "event-parse.h"
> > +
> > +static const char *input_buf;
> > +static unsigned long long input_buf_ptr;
> > +static unsigned long long input_buf_siz;
> > +
> > +static int show_warning = 1;
> > +
> > +#define do_warning(fmt, ...)				\
> > +	do {						\
> > +		if (show_warning)			\
> > +			warning(fmt, ##__VA_ARGS__);	\
> > +	} while (0)
> > +
> 
> Yeah, the name "do_warning" is awkward. Can we call it emit_warning or
> _warning or whatever?

As this is just a macro defined as a helper in this file (not global),
I'm not sure it needs to be changed. "emit" has two more characters to
type over "do" ;-)

> 
> > +static void init_input_buf(const char *buf, unsigned long long size)
> > +{
> > +	input_buf = buf;
> > +	input_buf_siz = size;
> > +	input_buf_ptr = 0;
> > +}
> > +
> > +const char *pevent_get_input_buf(void)
> > +{
> > +	return input_buf;
> > +}
> > +
> > +unsigned long long pevent_get_input_buf_ptr(void)
> > +{
> > +	return input_buf_ptr;
> > +}
> > +
> > +struct event_handler {
> > +	struct event_handler		*next;
> > +	int				id;
> > +	const char			*sys_name;
> > +	const char			*event_name;
> > +	pevent_event_handler_func	func;
> > +	void				*context;
> > +};
> > +
> > +struct pevent_func_params {
> > +	struct pevent_func_params	*next;
> > +	enum pevent_func_arg_type	type;
> > +};
> > +
> > +struct pevent_function_handler {
> > +	struct pevent_function_handler	*next;
> > +	enum pevent_func_arg_type	ret_type;
> > +	char				*name;
> > +	pevent_func_handler		func;
> > +	struct pevent_func_params	*params;
> > +	int				nr_args;
> > +};
> > +
> > +static unsigned long long
> > +process_defined_func(struct trace_seq *s, void *data, int size,
> > +		     struct event_format *event, struct print_arg *arg);
> > +
> > +static void free_func_handle(struct pevent_function_handler *func);
> > +
> > +/**
> 
> I see you're using kernel-doc style comments. Is this aimed at providing
> documentation for this library? If so, good idea!

That was the plan. It also forced me to document the API.

> 
> > + * pevent_buffer_init - init buffer for parsing
> > + * @buf: buffer to parse
> > + * @size: the size of the buffer
> > + *
> > + * For use with pevent_read_token(), this initializes the internal
> > + * buffer that pevent_read_token() will parse.
> > + */
> > +void pevent_buffer_init(const char *buf, unsigned long long size)
> > +{
> > +	init_input_buf(buf, size);
> > +}
> 
> Can't we unify pevent_buffer_init and init_input_buf()? I mean, it is
> useless to have that kind of indirection.

Yeah I agree. This was more of a historical artifact. It use to be just
init_input_buf() then I needed to export it for other users. Instead of
doing a full rename, I cheesed out and did this.

> 
> In general, is "pevent" the prefix for this library's functions which
> are getting exported to users?

Yep. It's the "namespace" used. But if people do not like it, we can
come up with another name. I just want it to be a short prefix.

> 
> > +
> > +void breakpoint(void)
> > +{
> > +	static int x;
> > +	x++;
> > +}
> 
> This looks like a debugging leftover since it is not used anywhere...?

Sorta. I kept it in trace-cmd on purpose, as I would set a breakpoint on
this function, and just manually add this function around the code, and
gdb would break on them. I found this easier than constantly needing to
add a breakpoint somewhere.

That said, it does not belong here and should be removed.

> 
> > +
> > +struct print_arg *alloc_arg(void)
> > +{
> > +	struct print_arg *arg;
> > +
> > +	arg = malloc_or_die(sizeof(*arg));
> > +	if (!arg)
> > +		return NULL;
> > +	memset(arg, 0, sizeof(*arg));
> > +
> > +	return arg;
> > +}
> > +
> > +struct cmdline {
> > +	char *comm;
> > +	int pid;
> > +};
> > +
> > +static int cmdline_cmp(const void *a, const void *b)
> > +{
> > +	const struct cmdline *ca = a;
> > +	const struct cmdline *cb = b;
> > +
> > +	if (ca->pid < cb->pid)
> > +		return -1;
> > +	if (ca->pid > cb->pid)
> > +		return 1;
> > +
> > +	return 0;
> > +}
> > +
> > +struct cmdline_list {
> > +	struct cmdline_list	*next;
> > +	char			*comm;
> > +	int			pid;
> > +};
> > +
> > +static int cmdline_init(struct pevent *pevent)
> > +{
> > +	struct cmdline_list *cmdlist = pevent->cmdlist;
> > +	struct cmdline_list *item;
> > +	struct cmdline *cmdlines;
> > +	int i;
> > +
> > +	cmdlines = malloc_or_die(sizeof(*cmdlines) * pevent->cmdline_count);
> > +
> > +	i = 0;
> > +	while (cmdlist) {
> > +		cmdlines[i].pid = cmdlist->pid;
> > +		cmdlines[i].comm = cmdlist->comm;
> > +		i++;
> > +		item = cmdlist;
> > +		cmdlist = cmdlist->next;
> > +		free(item);
> > +	}
> > +
> > +	qsort(cmdlines, pevent->cmdline_count, sizeof(*cmdlines), cmdline_cmp);
> > +
> > +	pevent->cmdlines = cmdlines;
> > +	pevent->cmdlist = NULL;
> > +
> > +	return 0;
> > +}
> > +
> > +static char *find_cmdline(struct pevent *pevent, int pid)
> > +{
> > +	const struct cmdline *comm;
> > +	struct cmdline key;
> > +
> > +	if (!pid)
> > +		return "<idle>";
> > +
> > +	if (!pevent->cmdlines)
> > +		cmdline_init(pevent);
> > +
> > +	key.pid = pid;
> > +
> > +	comm = bsearch(&key, pevent->cmdlines, pevent->cmdline_count,
> > +		       sizeof(*pevent->cmdlines), cmdline_cmp);
> > +
> > +	if (comm)
> > +		return comm->comm;
> > +	return "<...>";
> > +}
> > +
> > +/**
> > + * pevent_pid_is_registered - return if a pid has a cmdline registered
> > + * @pevent: handle for the pevent
> > + * @pid: The pid to check if it has a cmdline registered with.
> > + *
> > + * Returns 1 if the pid has a cmdline mapped to it
> > + * 0 otherwise.
> > + */
> > +int pevent_pid_is_registered(struct pevent *pevent, int pid)
> > +{
> > +	const struct cmdline *comm;
> > +	struct cmdline key;
> > +
> > +	if (!pid)
> > +		return 1;
> > +
> > +	if (!pevent->cmdlines)
> > +		cmdline_init(pevent);
> > +
> > +	key.pid = pid;
> > +
> > +	comm = bsearch(&key, pevent->cmdlines, pevent->cmdline_count,
> > +		       sizeof(*pevent->cmdlines), cmdline_cmp);
> > +
> > +	if (comm)
> > +		return 1;
> > +	return 0;
> > +}
> 
> This one looks almost identical to find_cmdline() above, maybe unify?

Similar but slightly different. Maybe they can be merged, but as they
are so small, it may not matter (for now).

> 
> > +
> > +/*
> > + * If the command lines have been converted to an array, then
> > + * we must add this pid. This is much slower than when cmdlines
> > + * are added before the array is initialized.
> > + */
> > +static int add_new_comm(struct pevent *pevent, const char *comm, int pid)
> > +{
> > +	struct cmdline *cmdlines = pevent->cmdlines;
> > +	const struct cmdline *cmdline;
> > +	struct cmdline key;
> > +
> > +	if (!pid)
> > +		return 0;
> > +
> > +	/* avoid duplicates */
> > +	key.pid = pid;
> > +
> > +	cmdline = bsearch(&key, pevent->cmdlines, pevent->cmdline_count,
> > +		       sizeof(*pevent->cmdlines), cmdline_cmp);
> > +	if (cmdline) {
> > +		errno = EEXIST;
> > +		return -1;
> > +	}
> > +
> > +	cmdlines = realloc(cmdlines, sizeof(*cmdlines) * (pevent->cmdline_count + 1));
> > +	if (!cmdlines) {
> > +		errno = ENOMEM;
> > +		return -1;
> > +	}
> > +
> > +	cmdlines[pevent->cmdline_count].pid = pid;
> > +	cmdlines[pevent->cmdline_count].comm = strdup(comm);
> > +	if (!cmdlines[pevent->cmdline_count].comm)
> > +		die("malloc comm");
> > +		
> 
> extraneous whitespace
> 
> > +	if (cmdlines[pevent->cmdline_count].comm)
> > +		pevent->cmdline_count++;
> > +
> > +	qsort(cmdlines, pevent->cmdline_count, sizeof(*cmdlines), cmdline_cmp);
> > +	pevent->cmdlines = cmdlines;
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * pevent_register_comm - register a pid / comm mapping
> > + * @pevent: handle for the pevent
> > + * @comm: the command line to register
> > + * @pid: the pid to map the command line to
> > + *
> > + * This adds a mapping to search for command line names with
> > + * a given pid. The comm is duplicated.
> > + */
> > +int pevent_register_comm(struct pevent *pevent, const char *comm, int pid)
> > +{
> > +	struct cmdline_list *item;
> > +
> > +	if (pevent->cmdlines)
> > +		return add_new_comm(pevent, comm, pid);
> > +
> > +	item = malloc_or_die(sizeof(*item));
> > +	item->comm = strdup(comm);
> > +	if (!item->comm)
> > +		die("malloc comm");
> > +	item->pid = pid;
> > +	item->next = pevent->cmdlist;
> > +
> > +	pevent->cmdlist = item;
> > +	pevent->cmdline_count++;
> > +
> > +	return 0;
> > +}
> > +
> > +struct func_map {
> > +	unsigned long long		addr;
> > +	char				*func;
> > +	char				*mod;
> > +};
> > +
> > +struct func_list {
> > +	struct func_list	*next;
> > +	unsigned long long	addr;
> > +	char			*func;
> > +	char			*mod;
> > +};
> > +
> > +static int func_cmp(const void *a, const void *b)
> > +{
> > +	const struct func_map *fa = a;
> > +	const struct func_map *fb = b;
> > +
> > +	if (fa->addr < fb->addr)
> > +		return -1;
> > +	if (fa->addr > fb->addr)
> > +		return 1;
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * We are searching for a record in between, not an exact
> > + * match.
> > + */
> > +static int func_bcmp(const void *a, const void *b)
> > +{
> > +	const struct func_map *fa = a;
> > +	const struct func_map *fb = b;
> > +
> > +	if ((fa->addr == fb->addr) ||
> > +
> 
> superfluous newline?
> 
> > +	    (fa->addr > fb->addr &&
> > +	     fa->addr < (fb+1)->addr))
> > +		return 0;
> > +
> > +	if (fa->addr < fb->addr)
> > +		return -1;
> > +
> > +	return 1;
> > +}
> > +
> > +static int func_map_init(struct pevent *pevent)
> > +{
> > +	struct func_list *funclist;
> > +	struct func_list *item;
> > +	struct func_map *func_map;
> > +	int i;
> > +
> > +	func_map = malloc_or_die(sizeof(*func_map) * (pevent->func_count + 1));
> > +	funclist = pevent->funclist;
> > +
> > +	i = 0;
> > +	while (funclist) {
> > +		func_map[i].func = funclist->func;
> > +		func_map[i].addr = funclist->addr;
> > +		func_map[i].mod = funclist->mod;
> > +		i++;
> > +		item = funclist;
> > +		funclist = funclist->next;
> > +		free(item);
> > +	}
> > +
> > +	qsort(func_map, pevent->func_count, sizeof(*func_map), func_cmp);
> > +
> > +	/*
> > +	 * Add a special record at the end.
> > +	 */
> > +	func_map[pevent->func_count].func = NULL;
> > +	func_map[pevent->func_count].addr = 0;
> > +	func_map[pevent->func_count].mod = NULL;
> > +
> > +	pevent->func_map = func_map;
> > +	pevent->funclist = NULL;
> > +
> > +	return 0;
> > +}
> > +
> > +static struct func_map *
> > +find_func(struct pevent *pevent, unsigned long long addr)
> > +{
> > +	struct func_map *func;
> > +	struct func_map key;
> > +
> > +	if (!pevent->func_map)
> > +		func_map_init(pevent);
> > +
> > +	key.addr = addr;
> > +
> > +	func = bsearch(&key, pevent->func_map, pevent->func_count,
> > +		       sizeof(*pevent->func_map), func_bcmp);
> > +
> > +	return func;
> 
> Simply do:
> 
> 	return bsearch(&key, ...);

That may have been caused by removing code (or adding debug between the
two).

But yeah, that should be simplified.

> 
> > +}
> > +
> > +/**
> > + * pevent_find_function - find a function by a given address
> > + * @pevent: handle for the pevent
> > + * @addr: the address to find the function with
> > + *
> > + * Returns a pointer to the function stored that has the given
> > + * address. Note, the address does not have to be exact, it
> > + * will select the function that would contain the address.
> > + */
> > +const char *pevent_find_function(struct pevent *pevent, unsigned long long addr)
> > +{
> > +	struct func_map *map;
> > +
> > +	map = find_func(pevent, addr);
> > +	if (!map)
> > +		return NULL;
> > +
> > +	return map->func;
> > +}
> > +
> > +/**
> > + * pevent_find_function_address - find a function address by a given address
> > + * @pevent: handle for the pevent
> > + * @addr: the address to find the function with
> > + *
> > + * Returns the address the function starts at. This can be used in
> > + * conjunction with pevent_find_function to print both the function
> > + * name and the function offset.
> > + */
> > +unsigned long long
> > +pevent_find_function_address(struct pevent *pevent, unsigned long long addr)
> > +{
> > +	struct func_map *map;
> > +
> > +	map = find_func(pevent, addr);
> > +	if (!map)
> > +		return 0;
> > +
> > +	return map->addr;
> > +}
> > +
> > +/**
> > + * pevent_register_function - register a function with a given address
> > + * @pevent: handle for the pevent
> > + * @function: the function name to register
> > + * @addr: the address the function starts at
> > + * @mod: the kernel module the function may be in (NULL for none)
> > + *
> > + * This registers a function name with an address and module.
> > + * The @func passed in is duplicated.
> > + */
> > +int pevent_register_function(struct pevent *pevent, char *func,
> > +			     unsigned long long addr, char *mod)
> > +{
> > +	struct func_list *item;
> > +
> > +	item = malloc_or_die(sizeof(*item));
> > +
> > +	item->next = pevent->funclist;
> > +	item->func = strdup(func);
> > +	if (mod)
> > +		item->mod = strdup(mod);
> > +	else
> > +		item->mod = NULL;
> > +	item->addr = addr;
> > +
> > +	pevent->funclist = item;
> > +
> > +	pevent->func_count++;
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * pevent_print_funcs - print out the stored functions
> > + * @pevent: handle for the pevent
> > + *
> > + * This prints out the stored functions.
> > + */
> > +void pevent_print_funcs(struct pevent *pevent)
> > +{
> > +	int i;
> > +
> > +	if (!pevent->func_map)
> > +		func_map_init(pevent);
> > +
> > +	for (i = 0; i < (int)pevent->func_count; i++) {
> 
> simply declare i as "unsigned int" and you don't need the cast here.

I think I did that once but it caused problems elsewhere. But we can
look at it again.

> 
> > +		printf("%016llx %s",
> > +		       pevent->func_map[i].addr,
> > +		       pevent->func_map[i].func);
> > +		if (pevent->func_map[i].mod)
> > +			printf(" [%s]\n", pevent->func_map[i].mod);
> > +		else
> > +			printf("\n");
> > +	}
> > +}
> > +
> > +struct printk_map {
> > +	unsigned long long		addr;
> > +	char				*printk;
> > +};
> > +
> > +struct printk_list {
> > +	struct printk_list	*next;
> > +	unsigned long long	addr;
> > +	char			*printk;
> > +};
> > +
> > +static int printk_cmp(const void *a, const void *b)
> > +{
> > +	const struct func_map *fa = a;
> > +	const struct func_map *fb = b;
> > +
> > +	if (fa->addr < fb->addr)
> > +		return -1;
> > +	if (fa->addr > fb->addr)
> > +		return 1;
> > +
> > +	return 0;
> > +}
> > +
> > +static void printk_map_init(struct pevent *pevent)
> > +{
> > +	struct printk_list *printklist;
> > +	struct printk_list *item;
> > +	struct printk_map *printk_map;
> > +	int i;
> > +
> > +	printk_map = malloc_or_die(sizeof(*printk_map) * (pevent->printk_count + 1));
> > +
> > +	printklist = pevent->printklist;
> > +
> > +	i = 0;
> > +	while (printklist) {
> > +		printk_map[i].printk = printklist->printk;
> > +		printk_map[i].addr = printklist->addr;
> > +		i++;
> > +		item = printklist;
> > +		printklist = printklist->next;
> > +		free(item);
> > +	}
> > +
> > +	qsort(printk_map, pevent->printk_count, sizeof(*printk_map), printk_cmp);
> > +
> > +	pevent->printk_map = printk_map;
> > +	pevent->printklist = NULL;
> > +}
> > +
> > +static struct printk_map *
> > +find_printk(struct pevent *pevent, unsigned long long addr)
> > +{
> > +	struct printk_map *printk;
> > +	struct printk_map key;
> > +
> > +	if (!pevent->printk_map)
> > +		printk_map_init(pevent);
> 
> You could pull those existence tests in the _init function above, i.e:
> 
> static void printk_map_init(struct pevent *pevent)
> {
> 	if (pevent->printk_map)
> 		return;
> 
> so that you can keep the init details to the init functions. Ditto for
> the remaining _init(..) calls.

Sure.

> 
> > +
> > +	key.addr = addr;
> > +
> > +	printk = bsearch(&key, pevent->printk_map, pevent->printk_count,
> > +			 sizeof(*pevent->printk_map), printk_cmp);
> > +
> > +	return printk;
> > +}
> > +
> > +/**
> > + * pevent_register_print_string - register a string by its address
> > + * @pevent: handle for the pevent
> > + * @fmt: the string format to register
> > + * @addr: the address the string was located at
> > + *
> > + * This registers a string by the address it was stored in the kernel.
> > + * The @fmt passed in is duplicated.
> > + */
> > +int pevent_register_print_string(struct pevent *pevent, char *fmt,
> > +				 unsigned long long addr)
> > +{
> > +	struct printk_list *item;
> > +
> > +	item = malloc_or_die(sizeof(*item));
> > +
> > +	item->next = pevent->printklist;
> > +	pevent->printklist = item;
> > +	item->printk = strdup(fmt);
> > +	item->addr = addr;
> > +
> > +	pevent->printk_count++;
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * pevent_print_printk - print out the stored strings
> > + * @pevent: handle for the pevent
> > + *
> > + * This prints the string formats that were stored.
> > + */
> > +void pevent_print_printk(struct pevent *pevent)
> > +{
> > +	int i;
> > +
> > +	if (!pevent->printk_map)
> > +		printk_map_init(pevent);
> 
> ditto.
> 
> > +
> > +	for (i = 0; i < (int)pevent->printk_count; i++) {
> 
> ditto for making i an unsigned int.
> 
> > +		printf("%016llx %s\n",
> > +		       pevent->printk_map[i].addr,
> > +		       pevent->printk_map[i].printk);
> > +	}
> > +}
> > +
> > +static struct event_format *alloc_event(void)
> > +{
> > +	struct event_format *event;
> > +
> > +	event = malloc_or_die(sizeof(*event));
> > +	memset(event, 0, sizeof(*event));
> 
> perf (or tools/) probably needs a zalloc_or_die which memset's the ptr
> to 0 - this'll save a bunch of code.

Yeah, agreed. I've just been too lazy to add them ;-)


> 
> > +
> > +	return event;
> > +}
> > +
> > +static void add_event(struct pevent *pevent, struct event_format *event)
> > +{
> > +	int i;
> > +
> > +	if (!pevent->events)
> > +		pevent->events = malloc_or_die(sizeof(event));
> > +	else
> > +		pevent->events =
> > +			realloc(pevent->events, sizeof(event) *
> > +				(pevent->nr_events + 1));
> > +	if (!pevent->events)
> > +		die("Can not allocate events");
> > +
> > +	for (i = 0; i < pevent->nr_events; i++) {
> > +		if (pevent->events[i]->id > event->id)
> > +			break;
> > +	}
> > +	if (i < pevent->nr_events)
> > +		memmove(&pevent->events[i + 1],
> > +			&pevent->events[i],
> > +			sizeof(event) * (pevent->nr_events - i));
> > +
> > +	pevent->events[i] = event;
> > +	pevent->nr_events++;
> > +
> > +	event->pevent = pevent;
> > +}
> > +
> > +static int event_item_type(enum event_type type)
> > +{
> > +	switch (type) {
> > +	case EVENT_ITEM ... EVENT_SQUOTE:
> > +		return 1;
> > +	case EVENT_ERROR ... EVENT_DELIM:
> > +	default:
> > +		return 0;
> > +	}
> > +}
> > +
> > +static void free_flag_sym(struct print_flag_sym *fsym)
> > +{
> > +	struct print_flag_sym *next;
> > +
> > +	while (fsym) {
> > +		next = fsym->next;
> > +		free(fsym->value);
> > +		free(fsym->str);
> > +		free(fsym);
> > +		fsym = next;
> > +	}
> > +}
> > +
> > +static void free_arg(struct print_arg *arg)
> > +{
> > +	struct print_arg *farg;
> > +
> > +	if (!arg)
> > +		return;
> > +
> > +	switch (arg->type) {
> > +	case PRINT_ATOM:
> > +		free(arg->atom.atom);
> > +		break;
> > +	case PRINT_FIELD:
> > +		free(arg->field.name);
> > +		break;
> > +	case PRINT_FLAGS:
> > +		free_arg(arg->flags.field);
> > +		free(arg->flags.delim);
> > +		free_flag_sym(arg->flags.flags);
> > +		break;
> > +	case PRINT_SYMBOL:
> > +		free_arg(arg->symbol.field);
> > +		free_flag_sym(arg->symbol.symbols);
> > +		break;
> > +	case PRINT_TYPE:
> > +		free(arg->typecast.type);
> > +		free_arg(arg->typecast.item);
> > +		break;
> > +	case PRINT_STRING:
> > +	case PRINT_BSTRING:
> > +		free(arg->string.string);
> > +		break;
> > +	case PRINT_DYNAMIC_ARRAY:
> > +		free(arg->dynarray.index);
> > +		break;
> > +	case PRINT_OP:
> > +		free(arg->op.op);
> > +		free_arg(arg->op.left);
> > +		free_arg(arg->op.right);
> > +		break;
> > +	case PRINT_FUNC:
> > +		while (arg->func.args) {
> > +			farg = arg->func.args;
> > +			arg->func.args = farg->next;
> > +			free_arg(farg);
> > +		}
> > +		break;
> > +
> > +	case PRINT_NULL:
> > +	default:
> > +		break;
> > +	}
> > +
> > +	free(arg);
> > +}
> > +
> > +static enum event_type get_type(int ch)
> > +{
> > +	if (ch == '\n')
> > +		return EVENT_NEWLINE;
> > +	if (isspace(ch))
> > +		return EVENT_SPACE;
> > +	if (isalnum(ch) || ch == '_')
> > +		return EVENT_ITEM;
> > +	if (ch == '\'')
> > +		return EVENT_SQUOTE;
> > +	if (ch == '"')
> > +		return EVENT_DQUOTE;
> > +	if (!isprint(ch))
> > +		return EVENT_NONE;
> > +	if (ch == '(' || ch == ')' || ch == ',')
> > +		return EVENT_DELIM;
> > +
> > +	return EVENT_OP;
> > +}
> > +
> > +static int __read_char(void)
> > +{
> > +	if (input_buf_ptr >= input_buf_siz)
> > +		return -1;
> > +
> > +	return input_buf[input_buf_ptr++];
> > +}
> > +
> > +static int __peek_char(void)
> > +{
> > +	if (input_buf_ptr >= input_buf_siz)
> > +		return -1;
> > +
> > +	return input_buf[input_buf_ptr];
> > +}
> > +
> > +/**
> > + * pevent_peek_char - peek at the next character that will be read
> > + *
> > + * Returns the next character read, or -1 if end of buffer.
> > + */
> > +int pevent_peek_char(void)
> > +{
> > +	return __peek_char();
> > +}
> > +
> > +static enum event_type force_token(const char *str, char **tok);
> > +
> > +static enum event_type __read_token(char **tok)
> > +{
> > +	char buf[BUFSIZ];
> > +	int ch, last_ch, quote_ch, next_ch;
> > +	int i = 0;
> > +	int tok_size = 0;
> > +	enum event_type type;
> > +
> > +	*tok = NULL;
> > +
> > +
> > +	ch = __read_char();
> > +	if (ch < 0)
> > +		return EVENT_NONE;
> > +
> > +	type = get_type(ch);
> > +	if (type == EVENT_NONE)
> > +		return type;
> > +
> > +	buf[i++] = ch;
> > +
> > +	switch (type) {
> > +	case EVENT_NEWLINE:
> > +	case EVENT_DELIM:
> > +		*tok = malloc_or_die(2);
> > +		(*tok)[0] = ch;
> > +		(*tok)[1] = 0;
> > +		return type;
> > +
> > +	case EVENT_OP:
> > +		switch (ch) {
> > +		case '-':
> > +			next_ch = __peek_char();
> > +			if (next_ch == '>') {
> > +				buf[i++] = __read_char();
> > +				break;
> > +			}
> > +			/* fall through */
> > +		case '+':
> > +		case '|':
> > +		case '&':
> > +		case '>':
> > +		case '<':
> > +			last_ch = ch;
> > +			ch = __peek_char();
> > +			if (ch != last_ch)
> > +				goto test_equal;
> > +			buf[i++] = __read_char();
> > +			switch (last_ch) {
> > +			case '>':
> > +			case '<':
> > +				goto test_equal;
> > +			default:
> > +				break;
> > +			}
> > +			break;
> > +		case '!':
> > +		case '=':
> > +			goto test_equal;
> > +		default: /* what should we do instead? */
> > +			break;
> > +		}
> > +		buf[i] = 0;
> > +		*tok = strdup(buf);
> > +		return type;
> > +
> > + test_equal:
> > +		ch = __peek_char();
> > +		if (ch == '=')
> > +			buf[i++] = __read_char();
> > +		goto out;
> > +
> > +	case EVENT_DQUOTE:
> > +	case EVENT_SQUOTE:
> > +		/* don't keep quotes */
> > +		i--;
> > +		quote_ch = ch;
> > +		last_ch = 0;
> > + concat:
> > +		do {
> > +			if (i == (BUFSIZ - 1)) {
> > +				buf[i] = 0;
> > +				if (*tok) {
> > +					*tok = realloc(*tok, tok_size + BUFSIZ);
> > +					if (!*tok)
> > +						return EVENT_NONE;
> > +					strcat(*tok, buf);
> > +				} else
> > +					*tok = strdup(buf);
> > +
> > +				if (!*tok)
> > +					return EVENT_NONE;
> > +				tok_size += BUFSIZ;
> > +				i = 0;
> > +			}
> > +			last_ch = ch;
> > +			ch = __read_char();
> > +			buf[i++] = ch;
> > +			/* the '\' '\' will cancel itself */
> > +			if (ch == '\\' && last_ch == '\\')
> > +				last_ch = 0;
> > +		} while (ch != quote_ch || last_ch == '\\');
> > +		/* remove the last quote */
> > +		i--;
> > +
> > +		/*
> > +		 * For strings (double quotes) check the next token.
> > +		 * If it is another string, concatinate the two.
> > +		 */
> > +		if (type == EVENT_DQUOTE) {
> > +			unsigned long long save_input_buf_ptr = input_buf_ptr;
> > +
> > +			do {
> > +				ch = __read_char();
> > +			} while (isspace(ch));
> > +			if (ch == '"')
> > +				goto concat;
> > +			input_buf_ptr = save_input_buf_ptr;
> > +		}
> > +
> > +		goto out;
> > +
> > +	case EVENT_ERROR ... EVENT_SPACE:
> > +	case EVENT_ITEM:
> > +	default:
> > +		break;
> > +	}
> > +
> > +	while (get_type(__peek_char()) == type) {
> > +		if (i == (BUFSIZ - 1)) {
> > +			buf[i] = 0;
> > +			if (*tok) {
> > +				*tok = realloc(*tok, tok_size + BUFSIZ);
> > +				if (!*tok)
> > +					return EVENT_NONE;
> > +				strcat(*tok, buf);
> > +			} else
> > +				*tok = strdup(buf);
> > +
> > +			if (!*tok)
> > +				return EVENT_NONE;
> > +			tok_size += BUFSIZ;
> > +			i = 0;
> > +		}
> > +		ch = __read_char();
> > +		buf[i++] = ch;
> > +	}
> > +
> > + out:
> > +	buf[i] = 0;
> > +	if (*tok) {
> > +		*tok = realloc(*tok, tok_size + i);
> > +		if (!*tok)
> > +			return EVENT_NONE;
> > +		strcat(*tok, buf);
> > +	} else
> > +		*tok = strdup(buf);
> > +	if (!*tok)
> > +		return EVENT_NONE;
> > +
> > +	if (type == EVENT_ITEM) {
> > +		/*
> > +		 * Older versions of the kernel has a bug that
> > +		 * creates invalid symbols and will break the mac80211
> > +		 * parsing. This is a work around to that bug.
> > +		 *
> > +		 * See Linux kernel commit:
> > +		 *  811cb50baf63461ce0bdb234927046131fc7fa8b
> > +		 */
> > +		if (strcmp(*tok, "LOCAL_PR_FMT") == 0) {
> > +			free(*tok);
> > +			*tok = NULL;
> > +			return force_token("\"\%s\" ", tok);
> > +		} else if (strcmp(*tok, "STA_PR_FMT") == 0) {
> > +			free(*tok);
> > +			*tok = NULL;
> > +			return force_token("\" sta:%pM\" ", tok);
> > +		} else if (strcmp(*tok, "VIF_PR_FMT") == 0) {
> > +			free(*tok);
> > +			*tok = NULL;
> > +			return force_token("\" vif:%p(%d)\" ", tok);
> > +		}
> > +	}
> > +
> > +	return type;
> > +}
> > +
> > +static enum event_type force_token(const char *str, char **tok)
> > +{
> > +	const char *save_input_buf;
> > +	unsigned long long save_input_buf_ptr;
> > +	unsigned long long save_input_buf_siz;
> > +	enum event_type type;
> > +	
> 
> Superfluous \t
> 
> > +	/* save off the current input pointers */
> > +	save_input_buf = input_buf;
> > +	save_input_buf_ptr = input_buf_ptr;
> > +	save_input_buf_siz = input_buf_siz;
> > +
> > +	init_input_buf(str, strlen(str));
> > +
> > +	type = __read_token(tok);
> > +
> > +	/* reset back to original token */
> > +	input_buf = save_input_buf;
> > +	input_buf_ptr = save_input_buf_ptr;
> > +	input_buf_siz = save_input_buf_siz;
> > +
> > +	return type;
> > +}
> > +
> > +static void free_token(char *tok)
> > +{
> > +	if (tok)
> > +		free(tok);
> > +}
> 
> According to MALLOC(3), free() can stomach NULL ptrs: "If ptr is NULL,
> no operation is performed."

Hmm, I know that. I wonder why I did it that way?

> 
> > +
> > +static enum event_type read_token(char **tok)
> > +{
> > +	enum event_type type;
> > +
> > +	for (;;) {
> > +		type = __read_token(tok);
> > +		if (type != EVENT_SPACE)
> > +			return type;
> > +
> > +		free_token(*tok);
> > +	}
> > +
> > +	/* not reached */
> > +	*tok = NULL;
> > +	return EVENT_NONE;
> > +}
> > +
> > +/**
> > + * pevent_read_token - access to utilites to use the pevent parser
> > + * @tok: The token to return
> > + *
> > + * This will parse tokens from the string given by
> > + * pevent_init_data().
> > + *
> > + * Returns the token type.
> > + */
> > +enum event_type pevent_read_token(char **tok)
> > +{
> > +	return read_token(tok);
> > +}
> 
> Same here: can't we remove all those wrappers and have the library
> routines be called "pevent_" or whatever and all users of the library
> simply call them?

Sure, we can. I probably did this just to keep the typing down ;-)

> 
> > +
> > +/**
> > + * pevent_free_token - free a token returned by pevent_read_token
> > + * @token: the token to free
> > + */
> > +void pevent_free_token(char *token)
> > +{
> > +	free_token(token);
> > +}
> 
> Ditto.

Ditto too!

> 
> > +
> > +/* no newline */
> 
> Please elaborate. Ah, event type cannot be NEWLINE additionally... Well,
> if that enum event_type were bits, you could unify this function with
> the read_token() above.

Perhaps, but that change is for another day.

> 
> > +static enum event_type read_token_item(char **tok)
> > +{
> > +	enum event_type type;
> > +
> > +	for (;;) {
> > +		type = __read_token(tok);
> > +		if (type != EVENT_SPACE && type != EVENT_NEWLINE)
> > +			return type;
> > +		free_token(*tok);
> > +		*tok = NULL;
> > +	}
> > +
> > +	/* not reached */
> > +	*tok = NULL;
> > +	return EVENT_NONE;
> > +}
> 
> Ok, enough for today. I'll review the rest only if you really want me to
> :-).
> 

Sure thanks for the comments now. The checkpatch clean ups should
probably be fixed before this goes in, and removing the breakpoint
function. But the other changes probably should wait. I would like what
goes in to be as close to what is in trace-cmd as possible. Perhaps, we
should add the cleanups as a separate patch. Just to have a nice
transition.

Thanks!

-- Steve


