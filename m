Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab2FNRft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 13:35:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53786 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756258Ab2FNRfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 13:35:47 -0400
From: David Ahern <dsahern@gmail.com>
To: rostedt@goodmis.org, acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        weisbec@gmail.com
Cc: namhyung.kim@lge.com, mingo@kernel.org, peterz@infradead.org,
        David Ahern <dsahern@gmail.com>
Subject: [RFC PATCH 1/2] libtraceevent: Add support for tracecmd plugins
Date: Thu, 14 Jun 2012 11:35:32 -0600
Message-Id: <1339695333-64591-2-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1339695333-64591-1-git-send-email-dsahern@gmail.com>
References: <1339695333-64591-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Plugin code pulled from trace-cmd repository as of 9a5cd1c1,
cherry-picked the plugin loading functions from trace-util.c
and declarations in trace-cmd.h

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/lib/traceevent/Makefile           |    2 +-
 tools/lib/traceevent/tracecmd-plugins.c |  280 +++++++++++++++++++++++++++++++
 tools/lib/traceevent/tracecmd-plugins.h |   34 ++++
 3 files changed, 315 insertions(+), 1 deletion(-)
 create mode 100644 tools/lib/traceevent/tracecmd-plugins.c
 create mode 100644 tools/lib/traceevent/tracecmd-plugins.h

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 3d69aa9..b1833ff 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -188,7 +188,7 @@ $(obj)/%.o: $(src)/%.c
 %.o: $(src)/%.c
 	$(Q)$(call do_compile)
 
-PEVENT_LIB_OBJS = event-parse.o trace-seq.o parse-filter.o parse-utils.o
+PEVENT_LIB_OBJS = event-parse.o trace-seq.o parse-filter.o parse-utils.o tracecmd-plugins.o
 
 ALL_OBJS = $(PEVENT_LIB_OBJS)
 
diff --git a/tools/lib/traceevent/tracecmd-plugins.c b/tools/lib/traceevent/tracecmd-plugins.c
new file mode 100644
index 0000000..24b004a
--- /dev/null
+++ b/tools/lib/traceevent/tracecmd-plugins.c
@@ -0,0 +1,280 @@
+/*
+ * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public
+ * License as published by the Free Software Foundation;
+ * version 2.1 of the License (not later!)
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public
+ * License along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <dirent.h>
+#include <ctype.h>
+#include <errno.h>
+#include <dlfcn.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <sys/mount.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+
+#include "tracecmd-plugins.h"
+
+#define LOCAL_PLUGIN_DIR ".trace-cmd/plugins"
+
+int tracecmd_disable_sys_plugins;
+int tracecmd_disable_plugins;
+
+
+static struct trace_plugin_options {
+	struct trace_plugin_options	*next;
+	char				*plugin;
+	char				*option;
+	char				*value;
+} *trace_plugin_options;
+
+#define _STR(x) #x
+#define STR(x) _STR(x)
+
+#ifndef MAX_PATH
+# define MAX_PATH 1024
+#endif
+
+static struct plugin_list {
+	struct plugin_list	*next;
+	char			*name;
+	void			*handle;
+};
+
+static void update_option(const char *file, struct plugin_option *option)
+{
+	struct trace_plugin_options *op;
+	char *plugin;
+
+	if (option->plugin_alias) {
+		plugin = strdup(option->plugin_alias);
+		if (!plugin)
+			die("malloc");
+	} else {
+		char *p;
+		plugin = strdup(file);
+		if (!plugin)
+			die("malloc");
+		p = strstr(plugin, ".");
+		if (p)
+			*p = '\0';
+	}
+
+	/* first look for named options */
+	for (op = trace_plugin_options; op; op = op->next) {
+		if (!op->plugin)
+			continue;
+		if (strcmp(op->plugin, plugin) != 0)
+			continue;
+		if (strcmp(op->option, option->name) != 0)
+			continue;
+
+		option->value = op->value;
+		option->set = 1;
+		goto out;
+	}
+
+	/* first look for unnamed options */
+	for (op = trace_plugin_options; op; op = op->next) {
+		if (op->plugin)
+			continue;
+		if (strcmp(op->option, option->name) != 0)
+			continue;
+
+		option->value = op->value;
+		option->set = 1;
+		break;
+	}
+
+ out:
+	free(plugin);
+}
+
+static void load_plugin(struct pevent *pevent, const char *path,
+			const char *file, void *data)
+{
+	struct plugin_list **plugin_list = data;
+	pevent_plugin_load_func func;
+	struct plugin_list *list;
+	struct plugin_option *options;
+	const char *alias;
+	char *plugin;
+	void *handle;
+
+	plugin = malloc_or_die(strlen(path) + strlen(file) + 2);
+
+	strcpy(plugin, path);
+	strcat(plugin, "/");
+	strcat(plugin, file);
+
+	handle = dlopen(plugin, RTLD_NOW | RTLD_GLOBAL);
+	if (!handle) {
+		warning("cound not load plugin '%s'\n%s\n",
+			plugin, dlerror());
+		goto out_free;
+	}
+
+	alias = dlsym(handle, PEVENT_PLUGIN_ALIAS_NAME);
+	if (!alias)
+		alias = file;
+
+	options = dlsym(handle, PEVENT_PLUGIN_OPTIONS_NAME);
+	if (options) {
+		while (options->name) {
+			update_option(alias, options);
+			options++;
+		}
+	}
+
+	func = dlsym(handle, PEVENT_PLUGIN_LOADER_NAME);
+	if (!func) {
+		warning("cound not find func '%s' in plugin '%s'\n%s\n",
+			PEVENT_PLUGIN_LOADER_NAME, plugin, dlerror());
+		goto out_free;
+	}
+
+	list = malloc_or_die(sizeof(*list));
+	list->next = *plugin_list;
+	list->handle = handle;
+	list->name = plugin;
+	*plugin_list = list;
+
+	pr_stat("registering plugin: %s", plugin);
+	func(pevent);
+	return;
+
+ out_free:
+	free(plugin);
+}
+
+static void
+trace_util_load_plugins_dir(struct pevent *pevent, const char *suffix,
+			    const char *path,
+			    void (*load_plugin)(struct pevent *pevent,
+						const char *path,
+						const char *name,
+						void *data),
+			    void *data)
+{
+	struct dirent *dent;
+	struct stat st;
+	DIR *dir;
+	int ret;
+
+	ret = stat(path, &st);
+	if (ret < 0)
+		return;
+
+	if (!S_ISDIR(st.st_mode))
+		return;
+
+	dir = opendir(path);
+	if (!dir)
+		return;
+
+	while ((dent = readdir(dir))) {
+		const char *name = dent->d_name;
+
+		if (strcmp(name, ".") == 0 ||
+		    strcmp(name, "..") == 0)
+			continue;
+
+		/* Only load plugins that end in suffix */
+		if (strcmp(name + (strlen(name) - strlen(suffix)), suffix) != 0)
+			continue;
+
+		load_plugin(pevent, path, name, data);
+	}
+
+	closedir(dir);
+
+	return;
+}
+
+void trace_util_load_plugins(struct pevent *pevent, const char *suffix,
+			     void (*load_plugin)(struct pevent *pevent,
+						 const char *path,
+						 const char *name,
+						 void *data),
+			     void *data)
+{
+	char *home;
+	char *path;
+        char *envdir;
+
+	if (tracecmd_disable_plugins)
+		return;
+
+/* If a system plugin directory was defined, check that first */
+#ifdef PLUGIN_DIR
+	if (!tracecmd_disable_sys_plugins)
+		trace_util_load_plugins_dir(pevent, suffix, PLUGIN_DIR,
+					    load_plugin, data);
+#endif
+
+	/* Next let the environment-set plugin directory override the system defaults */
+	envdir = getenv("TRACE_CMD_PLUGIN_DIR");
+	if (envdir)
+		trace_util_load_plugins_dir(pevent, suffix, envdir, load_plugin, data);
+
+	/* Now let the home directory override the environment or system defaults */
+	home = getenv("HOME");
+
+	if (!home)
+		return;
+
+	path = malloc_or_die(strlen(home) + strlen(LOCAL_PLUGIN_DIR) + 2);
+
+	strcpy(path, home);
+	strcat(path, "/");
+	strcat(path, LOCAL_PLUGIN_DIR);
+
+	trace_util_load_plugins_dir(pevent, suffix, path, load_plugin, data);
+
+	free(path);
+}
+
+struct plugin_list *tracecmd_load_plugins(struct pevent *pevent)
+{
+	struct plugin_list *list = NULL;
+
+	trace_util_load_plugins(pevent, ".so", load_plugin, &list);
+
+	return list;
+}
+
+void tracecmd_unload_plugins(struct plugin_list *plugin_list)
+{
+	pevent_plugin_unload_func func;
+	struct plugin_list *list;
+
+	while (plugin_list) {
+		list = plugin_list;
+		plugin_list = list->next;
+		func = dlsym(list->handle, PEVENT_PLUGIN_UNLOADER_NAME);
+		if (func)
+			func();
+		dlclose(list->handle);
+		free(list->name);
+		free(list);
+	}
+}
diff --git a/tools/lib/traceevent/tracecmd-plugins.h b/tools/lib/traceevent/tracecmd-plugins.h
new file mode 100644
index 0000000..1a65d50
--- /dev/null
+++ b/tools/lib/traceevent/tracecmd-plugins.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright (C) 2008, 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public
+ * License as published by the Free Software Foundation;
+ * version 2.1 of the License (not later!)
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public
+ * License along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+#ifndef _TRACECMD__PLUGINS_H
+#define _TRACECMD__PLUGINS_H
+
+#include <stdlib.h>
+#include "event-parse.h"
+
+extern int tracecmd_disable_sys_plugins;
+extern int tracecmd_disable_plugins;
+
+struct plugin_list;
+struct plugin_list *tracecmd_load_plugins(struct pevent *pevent);
+void tracecmd_unload_plugins(struct plugin_list *list);
+
+#endif /* _TRACECMD__PLUGINS_H */
-- 
1.7.10.1

